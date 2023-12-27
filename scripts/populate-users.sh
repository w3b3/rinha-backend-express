#!/bin/bash

# Define the base URL
BASE_URL="http://localhost:3000/users"

# Function to generate a random name with at least 10 characters
#generate_random_name() {
  # Set a minimum length for the random name
#  MIN_LENGTH=10

  # Initialize an empty string for the name
#  NAME=""

  # Loop until the name has at least 10 characters
#  while [ ${#NAME} -lt $MIN_LENGTH ]; do
    # Use /dev/urandom to generate random bytes, then convert to base64 to get ASCII characters
    # Use tr to remove characters that are not letters
#    NEW_CHAR=$(head /dev/urandom | tr -dc 'a-zA-Z')

    # Append the new character to the name
#    NAME="$NAME$NEW_CHAR"
#  done

#  echo "$NAME"
#}

# Function to convert a number to words
number_to_words() {
  local num=$1

# check if number is an integer and if not, make it integer
  if [[ $num =~ ^[0-9]+$ ]]; then
    num=$num
  else
    num=$(echo $num | cut -d'.' -f1)
  fi

# fix error saying "integer expression expected"
  if ! [[ "$num" =~ ^[0-9]+$ ]]; then
    num=0
  fi

  # Define arrays for words
  words=(zero one two three four five six seven eight nine ten eleven twelve)

  if [ $num -lt 12 ]; then
    echo "${words[$num]}"
  else
#    make a random elements from array
    echo "${words[$((RANDOM % 12))]}"
#    echo "${words[$RANDOM % 12]}"
#    echo "${words[$num]}"
  fi
}

# Function to create a unique string with the literal spelling of time components
create_unique_string() {
  # Get the current time components
  HOUR=$(date +"%H")
  MINUTE=$(date +"%M")
  SECOND=$(date +"%S")
  NANOSECOND=$(date +"%N")

  # Convert numeric values to words
  HOUR_WORD=$(number_to_words $HOUR)
  MINUTE_WORD=$(number_to_words $MINUTE)
  SECOND_WORD=$(number_to_words $SECOND)
  NANOSECOND_WORD=$(number_to_words $NANOSECOND)

  # Concatenate the words without spaces or numbers
  UNIQUE_STRING="${HOUR_WORD}${MINUTE_WORD}${SECOND_WORD}${NANOSECOND_WORD}"

  echo "$UNIQUE_STRING"
}

# Loop to create 10,000 users
for ((i=1; i<=100; i++)); do
  # Generate unique random name and email for each user
  SHARED_STRING=$(create_unique_string)
  NAME=$SHARED_STRING
  EMAIL="$SHARED_STRING$i@tld.ca"

  # Create JSON data for the user
  JSON_DATA='{
    "name": "'$NAME'",
    "email": "'$EMAIL'"
  }'

  # Send the POST request using curl
  curl -X POST -H "Content-Type: application/json" -d "$JSON_DATA" "$BASE_URL"
done
