#!/bin/bash

# where is our script contains;
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# A script, printing all file extensions in the directory without repeating;
outputAllFolderExtensions()
{
    for DIRECTORY in "${SCRIPT_DIR}"/../*; do
        if [ -d "${DIRECTORY}" ]; then
            # Ouput all files' extension without repeat in this directory;
            # I have found the answer there:
            #   https://stackoverflow.com/questions/1842254/how-can-i-find-all-of-the-distinct-file-extensions-in-a-folder-hierarchy
            for f in "${DIRECTORY}"/*.*; do 
                echo "${f##*.}"; 
            done
        fi
    done | sort -u  # remove all repeats and sort these;
}

main()
{
    echo "All extension files: "
    outputAllFolderExtensions
}

main