#!/bin/bash

# Ansible için port-forward yapılandırması oluştur
mkdir -p ansible/playbooks ansible/templates

# Ansible yapılandırma dosyasını güncelle, eğer yoksa oluştur
if [ ! -f "ansible/ansible.cfg" ]; then
    cat > ansible/ansible.cfg << 'EOF'
[defaults]
inventory = inventory.ini
host_key_checking = False
remote_user = furkanubuntu  # Bu kısmı kendi SSH kullanıcınız ile değiştirin
roles_path = roles

[privilege_escalation]
become = True
become_method = sudo
become_user = root
become_ask_pass = False
EOF
fi

# Envanter dosyasını güncelle, eğer yoksa oluştur
if [ ! -f "ansible/inventory.ini" ]; then
    cat > ansible/inventory.ini << 'EOF'
[all]
# Kubernetes/Docker sunucunuzun IP adresi veya localhost
server ansible_host=127.0.0.1 ansible_connection=local

[web_servers]
server

[kubernetes_master]
server

[kubernetes_nodes]
# Eğer ek worker node'lar varsa buraya ekleyin
EOF
fi

# Port-forward şablonlarını kopyala
cat > ansible/templates/port-forward.sh.j2 << 'EOF'
#!/bin/bash
# port-forward.sh.j2 - Kubernetes servislerini belirtilen lokal portlara yönlendirir

# PID dosyası dizini oluştur
mkdir -p {{ project_dir }}/pid

# Önceki port-forward işlemlerini temizle (ihtiyaç halinde)
if [ -f "{{ project_dir }}/pid/port-forward.pid" ]; then
    echo "Önceki port-forward işlemleri temizleniyor..."
    ./stop-port-forward.sh
fi

echo "Port-forward işlemleri başlatılıyor..."

{% for service in port_forwards %}
# {{ service.name }} servisi için port-forward
POD_NAME=$(kubectl get pod -l app={{ service.name }} -o jsonpath="{.items[0].metadata.name}")
if [ -n "$POD_NAME" ]; then
    echo "{{ service.name }} servisi için port-forward başlatılıyor: localhost:{{ service.local_port }} -> $POD_NAME:{{ service.pod_port }}"
    kubectl port-forward $POD_NAME {{ service.local_port }}:{{ service.pod_port }} > "{{ project_dir }}/{{ service.name }}-forward.log" 2>&1 &
    echo $! > "{{ project_dir }}/pid/{{ service.name }}-forward.pid"
else
    echo "HATA: {{ service.name }} servisi bulunamadı!"
fi
{% endfor %}

echo "Tüm port-forward işlemleri başlatıldı."
echo "Frontend için: http://localhost:80 adresini kullanabilirsiniz."
echo "API'ler şu adreslerde erişilebilir:"
{% for service in port_forwards %}
echo "- {{ service.name }}: http://localhost:{{ service.local_port }}"
{% endfor %}
echo ""
echo "Port-forward işlemlerini durdurmak için './stop-port-forward.sh' komutunu çalıştırın."
EOF

cat > ansible/templates/stop-port-forward.sh.j2 << 'EOF'
#!/bin/bash
# stop-port-forward.sh.j2 - Port-forward işlemlerini durdurur

echo "Port-forward işlemleri durduruluyor..."

# PID dizinindeki tüm port-forward işlemlerini durdur
if [ -d "{{ project_dir }}/pid" ]; then
    for pid_file in {{ project_dir }}/pid/*-forward.pid; do
        if [ -f "$pid_file" ]; then
            service_name=$(basename $pid_file | sed 's/-forward.pid//')
            pid=$(cat $pid_file)
            if ps -p $pid > /dev/null; then
                echo "$service_name servisi için port-forward durduruluyor (PID: $pid)"
                kill $pid
            else
                echo "$service_name servisi için port-forward zaten durdurulmuş."
            fi
            rm $pid_file
        fi
    done
fi

echo "Tüm port-forward işlemleri durduruldu."
EOF

# Playbook'ları oluştur
cat > ansible/playbooks/deploy-port-forward.yml << 'EOF'
---
- name: Uygulama Dağıtımı ve Port-Forward Ayarları
  hosts: kubernetes_master
  become: yes
  vars:
    project_dir: "/opt/microservices"
    # Port-forward için yerel portlar
    local_dortislem_port: 8081
    local_istatistik_port: 8082
    local_birimdonusum_port: 8083
  tasks:
    - name: Proje klasörünü oluştur
      file:
        path: "{{ project_dir }}"
        state: directory
        mode: '0755'

    - name: Proje dosyalarını kopyala
      copy:
        src: ../{{ item }}
        dest: "{{ project_dir }}/"
      with_items:
        - dortislem
        - istatistik
        - birimdonusum
        - frontend
        - docker-compose.yml
        - mikroservis-app.yaml
      
    - name: Docker imajlarını oluştur
      shell: docker-compose build
      args:
        chdir: "{{ project_dir }}"
      
    - name: Kubernetes'e uygulamayı dağıt
      shell: kubectl apply -f mikroservis-app.yaml
      args:
        chdir: "{{ project_dir }}"
      
    - name: Deploymentların hazır olmasını bekle
      shell: kubectl rollout status deployment/{{ item }}
      args:
        chdir: "{{ project_dir }}"
      with_items:
        - dortislem
        - istatistik
        - birimdonusum
        - frontend
      ignore_errors: yes
      
    - name: Uygulamanın durumunu kontrol et
      shell: kubectl get pods
      register: pod_status
      
    - name: Pod durumunu yazdır
      debug:
        var: pod_status.stdout_lines
        
    - name: Servisleri kontrol et
      shell: kubectl get services
      register: services
      
    - name: Servis durumlarını yazdır
      debug:
        var: services.stdout_lines

    # Port-forward yönetimi için playbook eklentileri
    - name: Port-forward betik dosyaları oluştur
      template:
        src: port-forward.sh.j2
        dest: "{{ project_dir }}/port-forward.sh"
        mode: '0755'
      vars:
        port_forwards:
          - name: dortislem
            local_port: "{{ local_dortislem_port }}"
            pod_port: 3001
          - name: istatistik
            local_port: "{{ local_istatistik_port }}"
            pod_port: 3002
          - name: birimdonusum
            local_port: "{{ local_birimdonusum_port }}"
            pod_port: 3003

    - name: Port-forward durdurma betiği oluştur
      template:
        src: stop-port-forward.sh.j2
        dest: "{{ project_dir }}/stop-port-forward.sh"
        mode: '0755'
EOF

cat > ansible/playbooks/start-port-forward.yml << 'EOF'
---
- name: Uygulamayı Port-Forward ile Başlat
  hosts: kubernetes_master
  become: yes
  vars:
    project_dir: "/opt/microservices"
  tasks:
    - name: Port-forward işlemini başlat
      shell: ./port-forward.sh
      args:
        chdir: "{{ project_dir }}"
      
    - name: Port-forward durumunu kontrol et
      shell: ps aux | grep port-forward | grep -v grep
      register: forward_status
      
    - name: Port-forward durumunu yazdır
      debug:
        var: forward_status.stdout_lines
EOF

cat > ansible/playbooks/stop-port-forward.yml << 'EOF'
---
- name: Uygulamanın Port-Forward İşlemini Durdur
  hosts: kubernetes_master
  become: yes
  vars:
    project_dir: "/opt/microservices"
  tasks:
    - name: Port-forward işlemini durdur
      shell: ./stop-port-forward.sh
      args:
        chdir: "{{ project_dir }}"
      
    - name: Port-forward durumunu kontrol et
      shell: ps aux | grep port-forward | grep -v grep
      register: forward_status
      ignore_errors: yes
      
    - name: Port-forward durumunu yazdır
      debug:
        msg: "Tüm port-forward işlemleri durduruldu. Aktif port-forward işlemi kalmadı."
      when: forward_status.rc != 0
EOF

echo "Port-forward için Ansible yapılandırması tamamlandı!"
echo ""
echo "Ansible komutlarını çalıştırmak için:"
echo "cd ansible"
echo "ansible-playbook playbooks/deploy-port-forward.yml  # Uygulamayı dağıt ve port-forward betiklerini oluştur"
echo "ansible-playbook playbooks/start-port-forward.yml   # Port-forward işlemini başlat"
echo "ansible-playbook playbooks/stop-port-forward.yml    # Port-forward işlemini durdur"