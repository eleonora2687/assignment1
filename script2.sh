#!/bin/bash

folder_name="repos"
dst_name="assignments"

# Check for input parameter
if [ -z $1 ]
then
    echo "Usage is: ./script2a.sh <archive name>"
    exit
fi

# Check if input file exists
if [ ! -f $1 ]
then
    echo "File " $1 "does not exist."
    exit
fi

# Check if destination folder exists
echo "Looking for the destination folder."
if [ -d $folder_name ]
then
    echo "Repos folder exists."
else
    # If the folder does not exist, create it
    echo "Repos folder not found. Creating..."
    mkdir -p $folder_name
fi

# Check if destination folder exists
echo "Looking for the destination folder."
if [ -d $dst_name ]
then
    echo "Assignments folder exists."
else
    # If the folder does not exist, create it
    echo "Assignments folder not found. Creating..."
    mkdir -p $dst_name
fi

# First, extract the archive
tar -xzf $1 -C $folder_name

# Find the txt files in the repos directory and store them
files=`find $folder_name -type f -name "*.txt"`
                                                                                                                                                                                         1,1           Top
# Find the txt files in the repos directory and store them
files=`find $folder_name -type f -name "*.txt"`
# Split the file names into an array
array=($files)
# Open each file and check its contents
for element in "${array[@]}"
do
    while IFS= read -r line
    do
    # Get the first character of each line to check for comments
    firstCharacter=${line:0:1}
    if [ $firstCharacter != "#" ]
    then
        # Clone the repo
        git -C $dst_name clone --quiet $line

        if [ $? != 0 ]
        then
            >&2 echo $line": Cloning FAILED"
                continue
        else
            echo $line": Cloning OK"
        fi

        # Break after reading the first link. The rest are skipped
        break
    fi
    done < "$element"
done

# Get all the directories in the 'assignment' directory
repos=`find $dst_name -mindepth 1 -maxdepth 1 -type d`
array=($repos)

# Iterate over the folders
for element in "${array[@]}"
do
    echo ${element:12}:
    # Get number of subdirectories, excluding hidden ones
    dirs=`find $element -mindepth 1 -type d -not -path '*/\.*' | wc -l`
    echo "Number of directories:" $dirs
    # Get number of txt files
     txts=`find $element -name '*.txt' | wc -l`
    echo "Number of txt files:" $txts
    # Get total number of files
    files=`find $element -type f | wc -l`
    echo "Number of of other files:" $((files-txts))

    # Check the structure
    if [ -f $element/"dataA.txt" ] && [ -d $element/"more/" ] \
        && [ -f $element/"more/dataB.txt" ] \
        && [ -f $element/"more/dataC.txt" ]
    then
        echo "Directory structure is OK."
    else
        echo "Directory structure is NOT OK."
    fi

done

                                     
