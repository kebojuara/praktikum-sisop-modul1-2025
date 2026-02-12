#!/bin/bash

log() {
echo "$(date '+%y/%m/%d %H:%M:%S') $1"
echo "$(date '+%y/%m/%d %H:%M:%S') $1" >> "/home/$user/cloud_storage/cloud_log.txt"
}
user=$(whoami)
login() {
read -p "Enter username: " username
read -p "Enter password: " password

pwlama=$(awk -F',' -v user="$username" '$1 == user {print $2}' "/home/$user/cloud_storage/users.txt")

if [[ -n "$pwlama" ]]; then
if [[ "$pwlama" == "$password" ]]; then

if grep -q "LOGIN: INFO User .* logged in" "/home/$user/cloud_storage/cloud_log.txt"; then

login1=$(grep "LOGIN: INFO User .* logged in" "/home/$user/cloud_storage/cloud_log.txt" | tail -n 1)
logout1=$(grep "LOGOUT: INFO User .* logged out" "/home/$user/cloud_storage/cloud_log.txt" | tail -n 1)

if [[ -z "$logout1" || "$login1" > "$logout1" ]]; then
log "LOGIN: ERROR Another user is currently logged in"
exit 1
fi
fi

crontab -l > "/home/$user/cloud_storage/crontabs"
crontab "/home/$user/cloud_storage/crontabs"

log "LOGIN: INFO User $username logged in"

else
log "LOGIN: ERROR Failed login attempt on user $username"
fi
else
log "LOGIN: ERROR User $username not found"
fi
}

logout() {
read -p "Enter username to logout: " username
if grep -q "LOGIN: INFO User $username" "/home/$user/cloud_storage/cloud_log.txt"; then
log "LOGOUT: INFO User $username logged out"
else
log "LOGOUT: ERROR User $username is not logged in"
fi
}

while true; do
echo "1. Login"
echo "2. Logout"
echo "3. Exit"
read -p "Choose an option: " option
case $option in
1) login ;;
2) logout ;;
3) break ;;
*) echo "ERROR Invalid option" ;;
esac
done
