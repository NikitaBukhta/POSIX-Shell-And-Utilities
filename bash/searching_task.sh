#!/bin/bash

# script location
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Find the first 20 occurrences of the word "_ asm" in *.c files;
# 
# Output lines with occurences to the screen;
function findFirst20WordsInFiles()
{
    local COUNT_OF_OCCURENCE
    local SEARCHING_WORD
    COUNT_OF_OCCURENCE=0    # how many occurences of specific word;
    SEARCHING_WORD="_asm"
    # get name and directory of every file with .c extension;
    # all ../c files are contained in src folder;
    for C_FILE in "${SCRIPT_DIR}"/../src/*.c
    do
        OUTPUT_STRING=$(grep "${SEARCHING_WORD}" "${C_FILE}")

        while read -r line; do
            echo "${line}"

            # -o option is what tells grep to output each match in a unique line
            # wc -l tells wc to count the number of lines
            local OCCURRENCES_IN_LINE
            OCCURRENCES_IN_LINE=$(grep -o "${SEARCHING_WORD}" <<< "${line}" | wc -l)
            ((COUNT_OF_OCCURENCE+="${OCCURRENCES_IN_LINE}"))
            
            # if we found first 20 occurences, just end the function
            if [[ ${COUNT_OF_OCCURENCE} -ge 20 ]]; then
                break
            fi
        done <<< "${OUTPUT_STRING}"
    done
}

function main()
{
    findFirst20WordsInFiles
}

main