#!/bin/bash

file_name="metrics_agg_$(date +%Y%m%d%H).log"
touch "$file_name"

declare -a min max sum count
first_file=true

min_size=999999999
max_size=0
sum_size_mb=0
count_size=0

for file in $(find "$(pwd)/metrics/" -name "metrics_*" -mmin -60); do
    if [[ $file == metrics_agg_* ]]; then
        continue
    fi
    line=$(awk 'NR==2' "$file")
    if [[ -n "$line" ]]; then
        IFS=, read value1 value2 value3 value4 value5 value6 value7 value8 value9 value10 value11 <<< "$line"
        values=($value1 $value2 $value3 $value4 $value5 $value6 $value7 $value8 $value9)
        if [[ "$first_file" == true ]]; then
            for i in {0..8}; do
                min[$i]=${values[$i]}
                max[$i]=${values[$i]}
                sum[$i]=${values[$i]}
            done
            first_file=false
        else
            for i in {0..8}; do
                if [[ ${values[$i]} -lt ${min[$i]} ]]; then
                    min[$i]=${values[$i]}
                fi
                if [[ ${values[$i]} -gt ${max[$i]} ]]; then
                    max[$i]=${values[$i]}
                fi
                sum[$i]=$((${sum[$i]} + ${values[$i]}))
            done
        fi

        numeric_part=$(echo "$value11" | grep -o '[0-9]\+')
        unit=$(echo "$value11" | grep -o '[KMG]')

        if [[ -n "$numeric_part" && -n "$unit" ]]; then
            if [[ "$unit" == "K" ]]; then
                size_mb=$(echo "scale=1; $numeric_part / 1024" | bc)
            elif [[ "$unit" == "G" ]]; then
                size_mb=$(echo "scale=1; $numeric_part * 1024" | bc)
            else
                size_mb=$numeric_part
            fi

            if [[ "$numeric_part" -lt "$min_size" ]]; then
                min_size=$numeric_part
                min_unit=$unit
            fi
            if [[ "$numeric_part" -gt "$max_size" ]]; then
                max_size=$numeric_part
                max_unit=$unit
            fi

            sum_size_mb=$(echo "scale=1; $sum_size_mb + $size_mb" | bc)
            count_size=$((count_size + 1))
        fi
    fi
done

average_size_mb=$(echo "scale=1; $sum_size_mb / $count_size" | bc)
average_size_mb=$(LC_NUMERIC=C printf "%0.1f" "$average_size_mb")

echo "type,mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" >> "$file_name"

echo -n "minimum," >> "$file_name"
for ((i=0; i<9; i++)); do
   printf "%d," "${min[$i]}" >> "$file_name"
done
echo -n "$(pwd)," >> "$file_name"
echo -n "$min_size" >> "$file_name"
echo -n "$min_unit" >> "$file_name"
echo >> "$file_name"

echo -n "maximum," >> "$file_name"
for ((i=0; i<9; i++)); do
   printf "%d," "${max[$i]}" >> "$file_name"
done
echo -n "$(pwd)," >> "$file_name"
echo -n "$max_size" >> "$file_name"
echo -n "$max_unit" >> "$file_name"
echo >> "$file_name"

echo -n "average," >> "$file_name"
for ((i=0; i<9; i++)); do
   average=$(echo "scale=1; ${sum[$i]} / $count_size" | bc)
   average=$(LC_NUMERIC=C printf "%0.1f" "$average")
   if [[ $(echo "$average" | grep -E "\.0+$") ]]; then
       printf "%d," "${average%.*}" >> "$file_name"
   else
       LC_NUMERIC=C printf "%0.1f," "$average" >> "$file_name"
   fi
done
echo -n "$(pwd)," >> "$file_name"
echo -n "$average_size_mb" >> "$file_name"
echo -n "M" >> "$file_name"
echo >> "$file_name"

chmod 200 "$file_name"
mv "$file_name" "/home/$USER/metrics"
