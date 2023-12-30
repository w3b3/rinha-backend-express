#!/bin/bash

# Define the base URL
BASE_URL="http://localhost:1234/usuarios"

generate_random_date() {
    year=$((RANDOM % (2023-1900+1) + 1900))   # Random year between 1990 and 2023
    month=$((RANDOM % 12 + 1))                # Random month between 1 and 12
    day=$((RANDOM % 31 + 1))                  # Random day between 1 and 28 (assuming all months have 28 days)

# IF DAY OR MONTH IS A SINGLE DIGIT, ADD A ZERO BEFORE IT
    if [ $month -lt 10 ]; then
        month="0$month"
    fi
    if [ $day -lt 10 ]; then
        day="0$day"
    fi
    echo "$year"-"$month"-"$day"
}

generate_uuid() {
#    uuid=$(cat /proc/sys/kernel/random/uuid)
    uuid=$(uuidgen)
    echo "${uuid:0:32}"
}

# function that returns a random letter from the alphabet
random_letter() {
    alphabet="abcdefghijklmnopqrstuvwxyz"
    echo ${alphabet:$((RANDOM % 26)):1}
}

#function that returns a random string of 10 letters
create_unique_string() {
    unique_string=""
    for ((i=1; i<=10; i++)); do
        unique_string="$unique_string$(random_letter)"
    done
#    echo "$unique_string"
# limit the string to 10 characters
    echo ${unique_string:0:32}
}

# function that return from 1 to 3 technologies from a list of 20 options
create_technologies() {
    technologies=("nodejs" "reactjs" "react-native" "angular" "vuejs" "java" "python" "c#" "c++" "c" "php" "ruby" "go" "swift" "kotlin" "scala" "rust" "haskell" "elixir" "clojure")
    echo "${technologies[$((RANDOM % 20))]}"
}

# build a function that uses create_technologies and concatenates 3 technologies, not allowing duplicates
concatenate_technologies() {
    tech1=$(create_technologies)
    tech2=$(create_technologies)
    tech3=$(create_technologies)
    while [ $tech1 == $tech2 ] || [ $tech1 == $tech3 ] || [ $tech2 == $tech3 ]; do
        tech1=$(create_technologies)
        tech2=$(create_technologies)
        tech3=$(create_technologies)
    done
    echo "$tech1,$tech2,$tech3"
}


# Loop to create 10,000 users
for ((i=1; i<=1000; i++)); do
  # Create JSON data for the user
  JSON_DATA='{
    "apelido": "'$(generate_uuid)'",
    "nome": "'$(create_unique_string)' '$(create_unique_string)'",
    "nascimento": "'$(generate_random_date)'",
    "stack": "{'$(concatenate_technologies)'}"
  }'
  # Send the POST request using curl
  curl -X POST -H "Content-Type: application/json" -d "$JSON_DATA" "$BASE_URL"
  echo "$JSON_DATA"
done
