#!/bin/bash

file_name="uptime_$(date +%Y%m%d%H).log"
touch "$file_name"
echo "uptime,load_avg_1min,load_avg_5min,load_avg_15min" >> "$file_name"
uptime | awk '{printf "%s %s %s", $1,$2,$3}' >> "$file_name"
cat /proc/loadavg | awk '{printf "%s,%s,%s\n", $1,$2,$3}' >> "$file_name"
chmod 200 "$file_name"
mv "$file_name" "/home/$USER/metrics"
