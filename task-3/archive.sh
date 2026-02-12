#!/bin/bash
LOGIN_USER=$(grep "LOGIN: INFO User" "/home/$USER/cloud_storage/cloud_log.txt" | tail -1 | awk -F'User ' '{print $2}' | awk '{print $1}')
download_dir="/home/$USER/cloud_storage/downloads/$LOGIN_USER"
archive_dir="/home/$USER/cloud_storage/archives/$LOGIN_USER"
mkdir -p "$archive_dir"
if [ -n "$(ls -A "$download_dir" 2>/dev/null)" ]; then
timestamp=$(date '+%Y%m%d_%H%M%S')
archive_file="$archive_dir/archive_$timestamp.zip"
zip -j "$archive_file" "$download_dir"/*
rm -f "$download_dir"/*
fi
