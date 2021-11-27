#!/bin/bash

# Check for input parameter
if [ -z $1 ]
then
    echo "Usage is: ./script1a.sh <filename>"
    exit
fi

# Check if input file exists
if [ ! -f $1 ]
then
    echo "File " $1 "does not exist."
    exit
fi
folder_name="downloads_a/"

# Check if downloads folder exists
echo "Looking for the downloads folder."
if [ -d $folder_name ]
then
    echo "Downloads folder exists."
else
     # If the folder does not exist, create it
    echo "Downloads folder not found. Creating..."
    mkdir -p $folder_name
fi

id=0

while IFS= read -r line
do
    # Get the first character of each line to check for comments
    firstCharacter=${line:0:1}
    if [ $firstCharacter != "#" ]
    then
        # Generate the filename for the file to download or check
        filename="${id}.html"

        # If the file exists, redownload the page and compare the two files
        if [ -f "$folder_name$filename" ]
        then
            filename_n="${id}_n.html"
            curl -s $line > "$folder_name$filename_n"

            # We check the return exit code of curl.
            # If it's not 0, an error has occured.
             # Source: https://everything.curl.dev/usingcurl/returns
            if [ $? != 0 ]
            then
                # Redirect STDOUT to STDERR and print the message
                >&2 echo $line "FAILED"
                continue
            fi

            # Compare the two files
            if cmp -s "$folder_name$filename" "$folder_name$filename_n";
            then
                echo $line "is up to date."
            else
                echo $line "has new content."
            fi

            # Delete the older file
            rm "$folder_name$filename"
            # Create a copy of the most recent file, removing the _n suffix
            cp "$folder_name$filename_n" "$folder_name$filename"
            # Delete the most recent file
            rm "$folder_name$filename_n"
        else
            # If the file does not exist, curl it
            curl -s $line > "$folder_name$filename"

            if [ $? != 0 ]
            then
                >&2 echo $line "FAILED"
                continue
            fi

            echo $line "INIT"
        fi

        #Increment the file counter
        id=$((id + 1))
    fi

done < "$1"
                                                                                                                                                                                         87,4          Bot

                                                                                                                                                                            1,4           Top

                                                         1,4           Top


