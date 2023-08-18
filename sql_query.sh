#!/bin/bash
start_time=$(date +%s%3N)
generate_dates() {
    j=$((1 + RANDOM % 7))
    new=$1
    new_date=$(date -d "$new + $j day" +%Y-%m-%d)
    echo "$new_date"
}
DB_NAME="DB"
TABLE_NAME="contacts"
CSV_FILE="generate.txt"
count=0
campaign_ID=1
start_date="2022-08-01"
valid_data=""
while IFS=, read -r line; do
    name=$(echo "$line" | cut -d',' -f1)
    email=$(echo "$line" | cut -d',' -f2)
    dob=$(echo "$line" | cut -d',' -f3)
    country=$(echo "$line" | cut -d',' -f4)
    city=$(echo "$line" | cut -d',' -f5)
    valid_data="('$name', '$email')"
    TABLE_NAME="contacts"
    inserted_id=$(mysql --defaults-file=~/.my.cnf $DB_NAME -e "INSERT INTO $TABLE_NAME (name, email) VALUES $valid_data;SELECT LAST_INSERT_ID();")
    last_inserted=${inserted_id##*)}
    last_inserted_id=$((last_inserted))
    echo $last_inserted

    json=("{\"dob\":\"$dob\",\"country\":\"$country\",\"city\":\"$city\"}")
    valid_data="('$last_inserted_id', '$json')"
    TABLE_NAME="contacts_details"
    mysql --defaults-file=~/.my.cnf $DB_NAME -e "INSERT INTO $TABLE_NAME (contacts_ID, json) VALUES $valid_data;"

    
    if [ $count -gt 10000 ]; then
        count=0
        campaign_ID=$((campaign_ID + 1))
        start_date=$(date -d "$start_date + 1 month" +%Y-%m-%d)
    fi

    type=()
    dates=()
    random_value=$((1 + RANDOM % 100))
    if [[ $random_value -gt 5 ]]; then
        type+=("1")
    else
        type+=("2")
    fi
    dates+=("$start_date")
    random_value=$((1 + RANDOM % 100))
    if [[ $random_value -gt 5 ]]; then
        type+=("3")
    fi
    res=($(generate_dates "$start_date"))
    dates+=("$res")
    random_value=$((1 + RANDOM % 100))
    if [[ $random_value -gt 5 ]]; then
        type+=("4")
    fi
    res=($(generate_dates "$res"))
    dates+=("$res")
    random_value=$((1 + RANDOM % 100))
    if [[ $random_value -gt 40 ]]; then
        ran=$((1 + RANDOM % 4))
        if [[ $ran -eq 1 ]]; then
            type+=("5")
        elif [[ $ran -eq 2 ]]; then
            type+=("6")
        else
            type+=("5")
            type+=("6")
        fi
    else
        type+=("7")
    fi
    res=($(generate_dates "$res"))
    dates+=("$res")
    values=""
    for ((i=0; i<${#type[@]}; i++)); do
        values+="('$last_inserted_id', '$campaign_ID', '${type[i]}', '${dates[i]}')"
        if [ $i -lt $((${#type[@]} - 1)) ]; then
            values+=", "
        fi
    done

    TABLE_NAME="contacts_activity"
    mysql --defaults-file=~/.my.cnf $DB_NAME -e "INSERT INTO $TABLE_NAME (contacts_ID, campaign_ID, activity_type, activity_date) VALUES $values;"

    count=$((count + 1))
done < "$CSV_FILE"


