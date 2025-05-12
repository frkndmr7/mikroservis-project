# Mikroservis Hesaplama Uygulaması

Bu proje, mikroservis mimarisi kullanan bir hesaplama uygulamasıdır. Projede dört işlem, istatistik hesaplamaları ve birim dönüşümleri yapan üç ayrı mikroservis ve bir frontend uygulaması bulunmaktadır.

## Mikroservisler

- **dortislem**: Toplama, çıkarma, çarpma ve bölme işlemleri yapar
- **istatistik**: Ortalama, medyan ve standart sapma hesaplamaları yapar
- **birimdonusum**: Çeşitli birim dönüşümleri yapar
- **frontend**: Kullanıcı arayüzü sunar

## Teknolojiler

- Backend: Node.js (Express) ve Python (Flask)
- Frontend: HTML, CSS, JavaScript
- Konteynerizasyon: Docker
- Orkestrasyson: Kubernetes
- Otomasyon: Ansible

## Kurulum ve Çalıştırma

### Docker Compose ile Çalıştırma

```bash
# Uygulamayı başlat
docker-compose up -d

# Durumu kontrol et
docker-compose ps

# Uygulamayı durdur
docker-compose down
```

### Kubernetes ile Çalıştırma

```bash
# Kubernetes'e deployment yap
kubectl apply -f mikroservis-app.yaml

# Port-forward ile servisleri yerel porta yönlendir
./kubernetes-tools/port-forward.sh

# Port-forward işlemlerini durdur
./kubernetes-tools/stop-port-forward.sh
```

### Ansible ile Otomasyon

```bash
# Gerekli bağımlılıklar
sudo apt update
sudo apt install ansible

# Uygulamayı Kubernetes'e dağıt
cd ansible
ansible-playbook playbooks/deploy-port-forward.yml

# Port-forward işlemini başlat
ansible-playbook playbooks/start-port-forward.yml

# Port-forward işlemini durdur
ansible-playbook playbooks/stop-port-forward.yml
```

## Erişim Bilgileri

Uygulama başladıktan sonra aşağıdaki adreslerden erişilebilir:

- Frontend: http://localhost:9090 (veya port-forward yapılandırmanıza göre)
- dortislem API: http://localhost:8081
- istatistik API: http://localhost:8082
- birimdonusum API: http://localhost:8083

## API Kullanımı

### Dört İşlem Servisi

```bash
# Toplama işlemi
curl -X POST http://localhost:8081/topla -H "Content-Type: application/json" -d '{"a": 5, "b": 3}'

# Çıkarma işlemi
curl -X POST http://localhost:8081/cikar -H "Content-Type: application/json" -d '{"a": 5, "b": 3}'

# Çarpma işlemi
curl -X POST http://localhost:8081/carp -H "Content-Type: application/json" -d '{"a": 5, "b": 3}'

# Bölme işlemi
curl -X POST http://localhost:8081/bol -H "Content-Type: application/json" -d '{"a": 6, "b": 3}'
```

### İstatistik Servisi

```bash
# Ortalama hesaplama
curl -X POST http://localhost:8082/ortalama -H "Content-Type: application/json" -d '{"sayilar": [1, 2, 3, 4, 5]}'

# Medyan hesaplama
curl -X POST http://localhost:8082/medyan -H "Content-Type: application/json" -d '{"sayilar": [1, 2, 3, 4, 5]}'

# Standart sapma hesaplama
curl -X POST http://localhost:8082/standart-sapma -H "Content-Type: application/json" -d '{"sayilar": [1, 2, 3, 4, 5]}'
```

### Birim Dönüşüm Servisi

```bash
# Kategorileri listele
curl -X GET http://localhost:8083/categories

# Belirli bir kategorideki birimleri listele
curl -X GET http://localhost:8083/units/uzunluk

# Birim dönüşümü yap
curl -X POST http://localhost:8083/convert -H "Content-Type: application/json" -d '{"deger": 100, "kaynakBirim": "cm", "hedefBirim": "m", "kategori": "uzunluk"}'
```

## Proje Yapısı

```
.
├── dortislem/             # Dört işlem mikroservisi (Node.js)
├── istatistik/            # İstatistik mikroservisi (Python)
├── birimdonusum/          # Birim dönüşüm mikroservisi (Node.js)
├── frontend/              # Frontend uygulaması (HTML/CSS/JS)
├── docker-compose.yml     # Docker Compose yapılandırması
├── mikroservis-app.yaml   # Kubernetes yapılandırması
├── ansible/               # Ansible otomasyon dosyaları
└── kubernetes-tools/      # Kubernetes yardımcı betikleri
```
