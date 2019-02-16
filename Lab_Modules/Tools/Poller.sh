#!/bin/bash

if [ -z "$1" ]; then
    echo "Please provide the public IP for the BookService"
    exit 0
fi

get_response_code () {
    curl -ILs -w %{http_code} -o /dev/null "$1"
}

RED="\033[0;31m"
GREEN="\033[0;32m"
GRAY="\033[0;37m"
NC="\033[0m"

get_response_color () {
   if [ 200 -eq "$1" ]; then
       echo "$GREEN"
   else
       echo "$RED"
   fi
}

get_line_color () {
   if [ 0 -eq $(($1%2)) ]; then
        echo "$NC"
   else
        echo "$GRAY"
   fi
}

BASE_URI="http://$1/api/BookData/Reviews"
COUNTER=0
echo "Entering call loop"
while true; do
    RESP1=$(get_response_code "$BASE_URI/1")
    RESP1C=$(get_response_color $RESP1)
    RESP2=$(get_response_code "$BASE_URI/2")
    RESP2C=$(get_response_color $RESP2)
    LC=$(get_line_color $COUNTER)
    echo -e "${LC}Call status codes: [Book id 1]:$RESP1C$RESP1$LC [Book id 2]:$RESP2C$RESP2$NC"
    COUNTER=$(($COUNTER+1))
    sleep 1
done
