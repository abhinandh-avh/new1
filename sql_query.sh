#!/bin/bash
start_time=$(date +%s%3N)
DB_NAME="employee"
TABLE_NAME="employee"
CSV_FILE="generate.txt"

while IFS= read -r line; do
    name=$(echo "$line" | cut -d',' -f1)
    email=$(echo "$line" | cut -d',' -f2)
    dob=$(echo "$line" | cut -d',' -f3)
    country=$(echo "$line" | cut -d',' -f4)
    city=$(echo "$line" | cut -d',' -f5)
    valid_data=("'$name', '$email'")
    TABLE_NAME="contacts"
    mysql --defaults-file=~/.my.cnf $DB_NAME <<EOF
    INSERT INTO $TABLE_NAME (name, email)
    VALUES $data_to_insert;
    EOF
    last_inserted_id=$(mysql --defaults-file=~/.my.cnf $DB_NAME -se "SELECT LAST_INSERT_ID();")
    json=("{\"dob\":\"${dob[$i]}\",\"country\":\"${country[$i]}\",\"city\":\"${city[$i]}\"}")
    valid_data=("'$last_inserted_id', '$json'")
    TABLE_NAME="contacts_activity"
    mysql --defaults-file=~/.my.cnf $DB_NAME <<EOF
    INSERT INTO $TABLE_NAME (name, email)
    VALUES $data_to_insert;
    EOF
done < "$CSV_FILE"


if [ $? -eq 0 ]; then
        end_time=$(date +%s%3N)
        execution_time=$((end_time - start_time))
        echo "Insertion completed successfully in $execution_time milliseconds."
    else
        echo "Insertion failed."
    fi
else
    echo "No valid data to insert."
fi
