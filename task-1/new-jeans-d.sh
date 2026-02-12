#!/bin/bash

cd ~/Downloads

unzip newjeans_analysis.zip
cd newjeans_analysis

awk -F, '
NR > 1 {
    gsub(/^ +| +$/, "", $7)
        sub(/\r$/, "", $7)
        total_durasi[$7] += $4
        user_per_device[$7 "-" $2] = 1
}

END {
    for (key in user_per_device) {
        split(key, arr, "-")
        dev = arr[1]
        unique_user[dev]++
    }
    user_terbanyak = -1
    durasi_tertinggi = -1
    rasio_loyal = -1

    printf "%-15s %-10s %-10s\n", "Device", "User", "Total Durasi (detik)"
        for (dev in total_durasi) {
            ratio = total_durasi[dev] / unique_user[dev]
            printf "%-15s %-10d %-10d\n", dev, unique_user[dev], total_durasi[dev]
            if (unique_user[dev] > user_terbanyak) {
                user_terbanyak = unique_user[dev]
                popular_device = dev
            }
            if (total_durasi[dev] > durasi_tertinggi) {
                durasi_tertinggi = total_durasi[dev]
                longest_device = dev
            }
            if (ratio > rasio_loyal) {
                rasio_loyal = ratio
                loyal_device = dev
            }
        }

    printf "\nDevice paling populer : " popular_device " (" user_terbanyak " user)\n"
    printf "Device menang durasi  : " longest_device " (" durasi_tertinggi " detik)\n"
    printf "Device Terloyal       : " loyal_device " (%.2f detik/user)\n", rasio_loyal
}' DataStreamer.csv
