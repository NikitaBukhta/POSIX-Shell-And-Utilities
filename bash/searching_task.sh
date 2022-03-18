#!/bin/bash

# where is our script contains
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Find the first 20 occurrences of the word "_ asm" in *.c files.
findFirst20WordsInFiles()
{
    COUNT_OF_OCCURENCE=0    # how many occurences of specific word;
    WORD="_asm"
    # get name of every file with .c extension;
    for c_file in "${SCRIPT_DIR}"../src/*.c
    do
        # get count of words of $WORD and write of in our variable;
        COUNT_OF_OCCURENCE=$((COUNT_OF_OCCURENCE+$(grep -c $WORD "$c_file")))
        
    if [ "$COUNT_OF_OCCURENCE" -ge 20 ]; then break; fi
    done

    echo "We have found ${COUNT_OF_OCCURENCE} more occurences"
}

findFirst20WordsInFiles