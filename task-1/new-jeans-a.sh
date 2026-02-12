#!/bin/bash

cd ~/Downloads

unzip newjeans_analysis.zip
cd newjeans_analysis

awk -F, '$2 ~ /[2]/ && $2 !~ /_/ {print $2}' DataStreamer.csv | sort | uniq -c | awk '{print $2} {total += $1} END {print "Total:", total}'
