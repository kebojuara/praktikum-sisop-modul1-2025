#!/bin/bash
read -p "Username: " username
read -p "Password: " password
user=$(whoami)
mkdir -p "/home/$user/cloud_storage/"
touch "/home/$user/cloud_storage/users.txt" "/home/$user/cloud_storage/cloud_log.txt"

isilog(){
echo "$(date '+%y/%m/%d %H:%M:%S') REGISTER: $1" >> "/home/$user/cloud_storage/cloud_log.txt"
}

if awk -v u="$username" -F, 'tolower($1) == tolower(u)' "/home/$user/cloud_storage/users.txt" | grep -q .; then
echo "ERROR User already exists"
isilog "ERROR User already exists"
exit 1
fi

if grep -q "LOGIN: INFO User .* logged in" "/home/$user/cloud_storage/cloud_log.txt"; then
last_login=$(grep "LOGIN: INFO User .* logged in" "/home/$user/cloud_storage/cloud_log.txt" | tail -n 1)
last_logout=$(grep "LOGOUT: INFO User .* logged out" "/home/$user/cloud_storage/cloud_log.txt" | tail -n 1)

if [[ -z "$last_logout" || "$last_login" > "$last_logout" ]]; then
echo "ERROR Cannot register while a user is logged in"
isilog "ERROR Cannot register while a user is logged in"
exit 1
fi
fi

if tail -n 1 "/home/$user/cloud_storage/cloud_log.txt" | grep -q "LOGIN:INFO User .* logged in"; then
echo "ERROR Cannot register while a user is logged in"
isilog "ERROR Cannot register while a user is logged in"
exit 1
fi

if [[ ${#password} -lt 8 ]]; then
echo "ERROR Password must be at least 8 characters"
isilog "ERROR Password must be at least 8 characters"
exit 1
fi

if [[ ! "$password" =~ [A-Z] ]]; then
echo "ERROR Password must contain an uppercase letter"
isilog "ERROR Password must contain an uppercase letter"
exit 1
fi

if [[ ! "$password" =~ [0-9] ]]; then
echo "ERROR Password must contain a number"
isilog "ERROR Password must contain a number"
exit 1
fi

if [[ ! "$password" =~ [^a-zA-Z0-9] ]]; then
echo "ERROR Password must contain a special character"
isilog "ERROR Password must contain a special character"
exit 1
fi

if [[ "$password" == "$username" ]]; then
echo "ERROR Password cannot be the same as username"
isilog "ERROR Password cannot be the same as username"
exit 1
fi

if [[ "$password" =~ cloud || "$password" =~ storage ]]; then
isilog "ERROR Password cannot contain 'cloud' or 'storage'"
echo "ERROR Password cannot contain 'cloud' or 'storage'"
exit 1
fi

echo "$username,$password" >> "/home/$user/cloud_storage/users.txt"
isilog "INFO User registered successfully"
echo "Registered"
