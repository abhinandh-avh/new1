#!/bin/bash
generate_name() {
    name=()
    generate_data  
    for ((i=0; i<${#data[@]}; i++)); do
        for ((j=1; j<2000; j++)); do  
            name+=("${data[i]}${j}")
        done
    done
}

generate_email() {
    email=()
    local domain=("google.com" "yahoo.com" "hotmail.com" "winmail.com" "vinam.com" "google.in" "vinam.co.in" "example1.co.in" "example2.ac.in" "example3.org.in")
    for i in "${name[@]}"; do
        local j="${domain[$((RANDOM % ${#domain[@]}))]}" 
        email+=("${i}@${j}")
    done
}

generate_details() {
    dob=()
    country=()
    city=()
    for ((i=0; i<${#name[@]}; i++)); do
        local year=$((RANDOM % ( 2010 - 1960 ) + 1960 ))
        local month=$((RANDOM % 12 + 1 ))
        local day=$((RANDOM % 28 + 1 ))
        local add="$year-$(printf %02d $month)-$(printf %02d $day)"
        dob+=("$add")
    done
    for ((i=0; i<20; i++)); do
        country+=("${data[i]}")
        city+=("$i")
    done
}


generate_data() {
    data=()
    for j in {A..Z}; do data+=("$j"); done
    for j in {a..z}; do data+=("$j"); done
}
generate_data
generate_name
generate_email
generate_details

for ((i=0; i<${#name[@]}; i++)); do
    country_index=$((RANDOM % ${#country[@]}))
    city_index=$((RANDOM % ${#city[@]}))
    echo "${name[$i]},${email[$i]},${dob[$i]},${country[$country_index]},${country[$country_index]}${city[$city_index]}"
done > generate.txt
