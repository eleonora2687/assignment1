#!/bin/bash
# Variable denoting the start of the book
work=false
# We are using an associative array
declare -A bow

# Read the file line by line
while IFS= read -r line
do
    # Get a substring from the file and check if the book starts
    if [ "${line:0:41}" = "*** START OF THIS PROJECT GUTENBERG EBOOK" ]
    then
        echo "STR"
        work=true
        continue
    # Check if the book ended
    elif [ "${line:0:39}" = "*** END OF THIS PROJECT GUTENBERG EBOOK" ]
    then
        echo "END"
        break
    fi

    # If we are in the book
    if [ "$work" = true ]
    then
        # Split the line into words
        array=($line)
        for element in "${array[@]}"
        do
            # Remove punctuation
            tmp=`echo $element | tr -d [:punct:]`
            
            # Convert to lowercase and increment.
            ((bow[${tmp,,}]++))
        done
    fi
done < "$1"

# Print the pairs
for key in "${!bow[@]}"
do
    echo "$key ${bow[$key]}"
done