#!/bin/bash

images=(
"https://media.istockphoto.com/id/471926619/id/foto/danau-moraine-saat-matahari-terbit-taman-nasional-banff-kanada.jpg?s=612x612&w=0&k=20&c=gTd7AEpKl3mHR_TCiyPSoG8JIiHEKg9NnhhHzNMAA1s="
"https://media.istockphoto.com/id/1161610609/id/foto/matahari-terbit-yang-indah-di-atas-laut.jpg?s=612x612&w=0&k=20&c=c5_d6b67GuSGP3w7LNJhALvOLgDVEVF5WH83oi5Ep5M="
"https://media.istockphoto.com/id/483724081/id/foto/yosemite-valley-landscape-and-river-california.jpg?s=612x612&w=0&k=20&c=tkTsD-xo5kKZexa-qoLwLFgilFRR5xpafDP367yHtRI="
"https://media.istockphoto.com/id/495508534/id/foto/pemandangan-udara-di-hutan-pinus-yang-luas-saat-matahari-terbit.jpg?s=612x612&w=0&k=20&c=BjvKAzVfWnEQ6JOwAgsqNPKwJ4gEax5E4L1IzPWJLo8="
"https://media.istockphoto.com/id/483076291/id/foto/hari-di-laut.jpg?s=612x612&w=0&k=20&c=63SIYJBuLRUe1Kn_Y44K8_spboWdaJjD95bgvDPrJ_Y="
"https://media.istockphoto.com/id/1168009842/id/foto/latar-belakang-udara-hutan-musim-gugur-campuran-berwarna-warni-dibuat-langsung-dari-atas.jpg?s=612x612&w=0&k=20&c=eUabVYYbgklXHNIC8R7URF2v3Sq7QauXvqUjrXImBPw="
"https://media.istockphoto.com/id/1696167872/id/foto/pemandangan-udara-hutan-saat-matahari-terbenam-dengan-latar-belakang-pegunungan-di-dolomites.jpg?s=612x612&w=0&k=20&c=iXJCimSdu1suE6RtA6Jf_6MysbIu_JubVdTpnxLvh98="
"https://media.istockphoto.com/id/1255610084/id/foto/ladang-lavender-tanpa-akhir-di-provence-prancis.jpg?s=612x612&w=0&k=20&c=3TKJAz6l-2mLuiUsAP5RR3XaGih6vdVmB1UKDXYORZM="
"https://media.istockphoto.com/id/1900503626/id/foto/matahari-terbenam-di-lupin-liar-dekat-mt-cook-selandia-baru.jpg?s=612x612&w=0&k=20&c=qxldBCpPDa5cJNCNjYhzfDdoEd5D2dG48z80jBFrCxo="
"https://media.istockphoto.com/id/935746242/id/foto/mata-atlantica-hutan-atlantik-di-brasil.jpg?s=612x612&w=0&k=20&c=xeqZsDGq3X7Rkke9JisTuMkF7Kc7tn1Woc1x9O18evI="
"https://media.istockphoto.com/id/526705622/id/foto/pegunungan-karst-dan-sungai-li-di-wilayah-guilin-guangxi-cina.jpg?s=612x612&w=0&k=20&c=tgDFeHrXxvuVMgsV77xFyAI9ZT5YSlKJnOqYjW95WEQ="
"https://media.istockphoto.com/id/1176527951/id/foto/matahari-terbit-lengkung-mesa.jpg?s=612x612&w=0&k=20&c=jUJp6fYJ2yBBTbfrTZXLp2UPWLmbktoXswKTO0ciO0Q="
"https://media.istockphoto.com/id/170464921/id/foto/matahari-terbit-yang-indah-di-pegunungan-pagi-berkabut.jpg?s=612x612&w=0&k=20&c=-ZKR7CfVIyRKNVkJGpzu-bmreJfuziP66K06yKgEv3M="
"https://media.istockphoto.com/id/108327817/id/foto/danau-plansee-tirol-austria.jpg?s=612x612&w=0&k=20&c=uV5bE60fIBLdMp89e3UBxnbL8bHLRH6EB9t4du-BhJ0="
)

LOGIN_USER=$(grep "LOGIN: INFO User" "/home/$USER/cloud_storage/cloud_log.txt" | tail -1 | awk -F'User ' '{print $2}' | awk '{print $1}')
DOWNLOAD_DIR="/home/$USER/cloud_storage/downloads/$LOGIN_USER"
mkdir -p "$DOWNLOAD_DIR"

filename="$DOWNLOAD_DIR/$(date '+%H-%M_%d-%m-%Y').jpg"
random_image="${images[$RANDOM % ${#images[@]}]}"
wget -q -O "$filename" "$random_image"
