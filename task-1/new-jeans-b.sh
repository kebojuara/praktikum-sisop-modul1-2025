#!/bin/bash

cd ~/Downloads

unzip newjeans_analysis.zip
cd newjeans_analysis

most_streamed=$(awk -F, '$2 ~ /[0-9]/ {print $3}' DataStreamer.csv | sort | uniq -c | sort -nr | head -n 1)

jumlah=$(echo "$most_streamed" | awk '{print $1}')

echo $most_streamed

if [ "$jumlah" -lt 24 ] 
then
  echo "Maaf, Minji, total streamingnya tidak sesuai harapan :("
else
  echo "Keren, Minji! Kamu hebat <3!"
fi
