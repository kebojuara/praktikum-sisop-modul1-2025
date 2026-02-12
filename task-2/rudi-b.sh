#!/bin/bash


read -p "Masukkan tanggal (format: MM/DD/YYYY): " tanggal
read -p "Masukkan IP Address (format: 192.168.1.X): " ip


computer=$(echo $ip | awk -F. '{print $4}')

penggunacomputer=$(awk -v tanggal="$tanggal" -v computer="$computer" -F, '
$1 == tanggal && $2 == computer {print $3}
' peminjaman_computer.csv)

if [ -n "$penggunacomputer" ]; then
    echo "Pengguna saat itu adalah $penggunacomputer"
    
    mkdir -p ./backup
    
    timenow=$(date +"%H%M%S")
    convertdate=$(date -d "$tanggal" +"%m%d%Y")
    namafile="./backup/${penggunacomputer}_${convertdate}_${timenow}.log"
    
    tanggallog=$(date -d "$tanggal" +"%d/%b/%Y")
    
    grep "^$ip" access.log | grep "$tanggallog" | while read -r baris; do
        method=$(echo "$baris" | awk -F'"' '{print $2}' | awk '{print $1}')
        endpoint=$(echo "$baris" | awk -F'"' '{print $2}' | awk '{print $2}')
        statuscode=$(echo "$baris" | awk '{print $9}')
        
        timestamp=$(echo "$baris" | awk -F'[' '{print $2}' | awk -F']' '{print $1}')
        
        echo "[$timestamp]: $method - $endpoint - $statuscode" >> "$namafile"
    done
    
    echo "Log Aktivitas $penggunacomputer"
else
    echo "Data yang kamu cari tidak ada"
fi
