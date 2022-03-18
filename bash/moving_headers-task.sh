#!/bin/bash

# where is our script contains
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. "${SCRIPT_DIR}/settingEditor.sh"

# Copy all * .h files to `my-headers` directory.
# $1 - from which folder directory we get files
# $2 - to which directory we copy files
# $3 - which file we copy
#
# return 1 if file isn't $3
copyFilesToFolder()
{
    # if that is file
    if [ -f "$1" ]; then
        if [[ "$1" == "$3" ]]; then
            cp "${1}" "${2}"
            return 0
        fi

        return 1
    fi

    for FILE in ${1}/${3}
    do
        #if one *.h file exists
        if [ -e "${FILE}" ]; then
            # check if folder is exist in specific directory;
            # if not we create a folder;
            if [ ! -d "${2}" ]; then
                mkdir "${2}"
            fi

            # copy all header file to this folder;
            cp "${FILE}" "${2}"
            
        fi
    done

    return 0
}

main()
{
    if [ ! -f .my-settings.txt ]; then
        setStandartSettings
    fi

    # get INST_DATADIR setting
    INST_DATADIR=$(cut -d "=" -f2- <<< "$(grep INST_DATADIR= "${SCRIPT_DIR}"/.my-settings.txt)")

    # check every file and folder in INST_DATADIR directory
    for FOLDER in "${INST_DATADIR}"/*; do
        copyFilesToFolder "${FOLDER}" "${INST_DATADIR}/my-headers" "*.h"
    done
}

main