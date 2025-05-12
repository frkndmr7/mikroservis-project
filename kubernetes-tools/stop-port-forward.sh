#!/bin/bash
# stop-port-forward.sh.j2 - Port-forward işlemlerini durdurur

echo "Port-forward işlemleri durduruluyor..."

# PID dizinindeki tüm port-forward işlemlerini durdur
if [ -d "/home/furkanubuntu/microservices/pid" ]; then
    for pid_file in /home/furkanubuntu/microservices/pid/*-forward.pid; do
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
