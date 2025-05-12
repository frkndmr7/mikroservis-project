#!/bin/bash
# port-forward.sh.j2 - Kubernetes servislerini belirtilen lokal portlara yönlendirir

# PID dosyası dizini oluştur
mkdir -p /home/furkanubuntu/microservices/pid

# Önceki port-forward işlemlerini temizle (ihtiyaç halinde)
if [ -f "/home/furkanubuntu/microservices/pid/port-forward.pid" ]; then
    echo "Önceki port-forward işlemleri temizleniyor..."
    ./stop-port-forward.sh
fi

echo "Port-forward işlemleri başlatılıyor..."

# dortislem servisi için port-forward
POD_NAME=$(kubectl get pod -l app=dortislem -o jsonpath="{.items[0].metadata.name}")
if [ -n "$POD_NAME" ]; then
    echo "dortislem servisi için port-forward başlatılıyor: localhost:8081 -> $POD_NAME:3001"
    kubectl port-forward $POD_NAME 8081:3001 > "/home/furkanubuntu/microservices/dortislem-forward.log" 2>&1 &
    echo $! > "/home/furkanubuntu/microservices/pid/dortislem-forward.pid"
else
    echo "HATA: dortislem servisi bulunamadı!"
fi
# istatistik servisi için port-forward
POD_NAME=$(kubectl get pod -l app=istatistik -o jsonpath="{.items[0].metadata.name}")
if [ -n "$POD_NAME" ]; then
    echo "istatistik servisi için port-forward başlatılıyor: localhost:8082 -> $POD_NAME:3002"
    kubectl port-forward $POD_NAME 8082:3002 > "/home/furkanubuntu/microservices/istatistik-forward.log" 2>&1 &
    echo $! > "/home/furkanubuntu/microservices/pid/istatistik-forward.pid"
else
    echo "HATA: istatistik servisi bulunamadı!"
fi
# birimdonusum servisi için port-forward
POD_NAME=$(kubectl get pod -l app=birimdonusum -o jsonpath="{.items[0].metadata.name}")
if [ -n "$POD_NAME" ]; then
    echo "birimdonusum servisi için port-forward başlatılıyor: localhost:8083 -> $POD_NAME:3003"
    kubectl port-forward $POD_NAME 8083:3003 > "/home/furkanubuntu/microservices/birimdonusum-forward.log" 2>&1 &
    echo $! > "/home/furkanubuntu/microservices/pid/birimdonusum-forward.pid"
else
    echo "HATA: birimdonusum servisi bulunamadı!"
fi

echo "Tüm port-forward işlemleri başlatıldı."
echo "Frontend için: http://localhost:80 adresini kullanabilirsiniz."
echo "API'ler şu adreslerde erişilebilir:"
echo "- dortislem: http://localhost:8081"
echo "- istatistik: http://localhost:8082"
echo "- birimdonusum: http://localhost:8083"
echo ""
echo "Port-forward işlemlerini durdurmak için './stop-port-forward.sh' komutunu çalıştırın."
# Frontend servisi için port-forward
POD_NAME=$(kubectl get pod -l app=frontend -o jsonpath="{.items[0].metadata.name}")
if [ -n "$POD_NAME" ]; then
    echo "frontend servisi için port-forward başlatılıyor: localhost:9000 -> $POD_NAME:80"
    kubectl port-forward $POD_NAME 9000:80 > "~/microservices/frontend-forward.log" 2>&1 &
    echo $! > "~/microservices/pid/frontend-forward.pid"
else
    echo "HATA: frontend servisi bulunamadı!"
fi

echo "Frontend: http://localhost:9000"
