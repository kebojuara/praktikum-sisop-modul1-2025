#!/bin/bash

cd ~/Downloads

unzip newjeans_analysis.zip
cd newjeans_analysis

most_streamed=$(awk -F, '$2 ~ /[0-9]/{print $3}' DataStreamer.csv | sort | uniq -c | sort -nr | head -n 1 | awk '{$1=$1};1')

jumlah=$(echo "$most_streamed" | awk '{print $1}')

nama_lagu=$(echo "$most_streamed" | awk '{$1=""; print $0}' | sed 's/^ //')

album_info=$(sed -n "/,$nama_lagu,/p" AlbumDetails.csv | awk -F, '{print $1, $3}')

echo "$nama_lagu $jumlah"
echo "$album_info"
