#!/bin/bash

file_name="metrics_$(date +%Y%m%d%H%M%S).log"	
touch "$file_name"
echo "mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" >> "$file_name"
free -m | awk 'NR==2 {printf "%s,%s,%s,%s,%s,%s,", $2,$3,$4,$5,$6,$7} NR==3 {printf "%s,%s,%s,", $2,$3,$4}' >> "$file_name"
echo -n "$(pwd)," >> "$file_name"
du -sh $(pwd) | awk '{print $1}' >> "$file_name"
chmod 200 "$file_name"
mv "$file_name" "/home/$USER/metrics"
