#!/bin/bash


echo "Total Request yang Dibuat oleh Setiap IP:"
awk '{print $1}' access.log | sort | uniq -c | sort -nr

echo -e "\nJumlah dari Setiap Status Code:"
awk '{print $9}' access.log | sort | uniq -c | sort -nr
