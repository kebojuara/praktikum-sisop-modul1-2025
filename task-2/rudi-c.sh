#!/bin/bash


tempcount=$(mktemp)
tempdateip=$(mktemp)

grep " 500 " "access.log" | awk '
BEGIN {
    convertmonth["Jan"] = "01";
    convertmonth["Feb"] = "02";
    convertmonth["Mar"] = "03";
    convertmonth["Apr"] = "04";
    convertmonth["May"] = "05";
    convertmonth["Jun"] = "06";
    convertmonth["Jul"] = "07";
    convertmonth["Aug"] = "08";
    convertmonth["Sep"] = "09";
    convertmonth["Oct"] = "10";
    convertmonth["Nov"] = "11";
    convertmonth["Dec"] = "12";
}
{
    ip = $1;
    pdate = $4;
    gsub(/[\[\]]/, "", pdate);
    split(pdate, pdates, ":");
    stringdate = pdates[1];

    split(stringdate, arraydate, "/");
    day = arraydate[1];
    month = convertmonth[arraydate[2]];
    year = arraydate[3];

    mmddyyyy = month "/" day "/" year;

    split(ip, ipparts, ".");
    computer = ipparts[4];

    print mmddyyyy "," computer;
}' | sort > "$tempdateip"

jumlahandi=0
jumlahbudi=0
jumlahcaca=0

declare -A arrayuser

while IFS=, read -r date compy name; do
    if [ "$date" = "Tanggal" ]; then
        continue
    fi
    
    key="${date},${compy}"
    arrayuser["$key"]="$name"
done < "peminjaman_computer.csv"

while IFS=, read -r date compy; do
    key="${date},${compy}"
    user="${arrayuser[$key]}"
    
    if [ -n "$user" ]; then
        case "$user" in
            "Andi")
                jumlahandi=$((jumlahandi + 1))
                ;;
            "Budi")
                jumlahbudi=$((jumlahbudi + 1))
                ;;
            "Caca")
                jumlahcaca=$((jumlahcaca + 1))
                ;;
        esac
    fi
done < "$tempdateip"

rm "$tempdateip" "$tempcount"

if [ "$jumlahandi" -ge "$jumlahbudi" ] && [ "$jumlahandi" -ge "$jumlahcaca" ]; then
    winner="Andi"
    jumlah="$jumlahandi"
elif [ "$jumlahbudi" -ge "$jumlahandi" ] && [ "$jumlahbudi" -ge "$jumlahcaca" ]; then
    winner="Budi"
    jumlah="$jumlahbudi"
else
    winner="Caca"
    jumlah="$jumlahcaca"
fi

echo "Pengguna dengan Status Code 500 terbanyak adalah $winner dengan jumlah $jumlah."
