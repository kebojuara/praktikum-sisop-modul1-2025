#!/bin/bash

if grep -q "LOGIN: INFO User .* logged in" "/home/$USER/cloud_storage/cloud_log.txt"; then
login1=$(grep "LOGIN: INFO User .* logged in" "/home/$USER/cloud_storage/cloud_log.txt" | tail -n 1)
logout1=$(grep "LOGOUT: INFO User .* logged out" "/home/$USER/cloud_storage/cloud_log.txt" | tail -n 1)
if [[ -z "$logout1" || "$login1" > "$logout1" ]]; then
bash "/home/$USER/cloud_storage/scripts/download.sh"
else
crontab -r
fi
else
crontab -r
fi
