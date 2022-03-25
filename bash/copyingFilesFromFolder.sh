#!/bin/bash

# script location
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. "${SCRIPT_DIR}/settingEditor.sh"
DATADIR=${PWD}                                  # files location
PKG_MOVING_ROOT="${HOME}/Documents/my-headers"  # moving location
MOVING_FILE_EXTENSION=".h"                      # files extension

# Copy all * .h files to `my-headers` directory.
# $1 - from which folder directory we get files
# $2 - to which directory we copy files
# $3 - which file we copy
#
# return 1 if file isn't $3
function copyFilesFromFolder()
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

# output brief of script
function helpCommand()
{
    echo "./copyingFilesFromFolder.sh [option_1] [value] [option_2] [value_2]"
    echo "or"
    echo echo "./copyingFilesFromFolder.sh [options] [value_1 value_2 ...]"
    echo "This script help you to copy certain files from one folder to another. " + 
        "By default we have the next settings:"
    echo "DATADIR: ${DATADIR}"
    echo "    That is a files location"
    echo "PKG_MOVING_ROOT: ${PKG_MOVING_ROOT}"
    echo "    That is a moving location"
    echo "MOVING_FILE_EXTENSION: ${MOVING_FILE_EXTENSION}"
    echo "    That is files extension"
    echo "-----------------------------------"
    echo "Options:"
    echo "    -e -- file extension. File with which extension we want to move"
    echo "    --extension -- the same as -e"
    echo "    -f -- from which directory you want to copy files"
    echo "    --from - the same as -f"
    echo "    -h -- output script brief"
    echo "    --help -- the same as -h"
    echo "    -r -- check subdirectories for containing files"
    echo "    --recursion -- the same as -r"
    echo "    -t -- to which directory you want to copy files. If this directory is not " + 
        "exits, it will be created"
    echo "    --to - the same as -t"
    echo "-----------------------------------"
    echo "Errors:"
    echo "    1 - cannot oopen the directory."
}

# set new DATADIR value
#
# $1 - directory you want to set
function fromCommand()
{
    local allFolders
    local HOME_DIRECTORY_CHECKED

    allFolders=$(tr '/' ' ' <<< "$1")
    # we haven't gone over the home directory, so we have 
    # set it to 0 in order to cd the HOME dir
    HOME_DIRECTORY_CHECKED=0
    for folder in ${allFolders}; do
        if [[ ! -e ${folder} ]]; then
            # if that is part of home directory and we haven't gone from all the way yet
            if [[ "${HOME}" = *${folder}* && $HOME_DIRECTORY_CHECKED -eq 0 ]]; then
                cd "${HOME}" || exit 1
                continue
            elif [[ ! -e $folder ]]; then
                mkdir "${PWD}/${folder}"
                HOME_DIRECTORY_CHECKED=1
            fi
        fi

        cd "${folder}" || exit 1
        echo "PWD: $PWD"
    done
    
    DATADIR=${1}
}

function main()
{
    if [ ! -f .my-settings.txt ]; then
        setStandartSettings
    fi

    # get INST_DATADIR setting
    INST_DATADIR=$(cut -d "=" -f2- <<< "$(grep INST_DATADIR= "${SCRIPT_DIR}"/.my-settings.txt)")

    # check every file and folder in INST_DATADIR directory
    for FOLDER in "${DATADIR}"/*; do
        copyFilesFromFolder "${FOLDER}" "${INST_DATADIR}/my-headers" "*.h"
    done
}

function test()
{
    #fromCommand "${HOME}/Documents/someDir1/test/test105"
    helpCommand
}
test