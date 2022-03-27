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

# change moving file extension
#
# $1 - new file extension
function extensionCommand()
{
    MOVING_FILE_EXTENSION="${1}"
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
                HOME_DIRECTORY_CHECKED=1
            fi
        fi

        cd "${folder}" || exit 1
    done
    
    DATADIR=${1}
}

# output brief of script
function helpCommand()
{
    echo "./copyingFilesFromFolder.sh [option_1] [value] [option_2] [value_2]"
    echo "This script help you to copy certain files from one folder to another. By default we have the next settings:"
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
    echo "    -t -- to which directory you want to copy files. If this directory is not exits, it will be created"
    echo "    --to - the same as -t"
    echo "-----------------------------------"
    echo "Errors:"
    echo "    1 - cannot open the directory."
}
# set new PKG_MOVING_ROOT value
#
# $1 - directory you want to set
function toCommand()
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
    done
    
    PKG_MOVING_ROOT=${1}
}

# check all options from all args to change standart settings;
#
# $[unpair_number] - option ($1, $3...)
# $[pair_number] - option_arg ($2, $4...)
function checkOptions()
{
    local ARG   # args for options
    # which options user has choosen. This option is needed to write off
    #   the value of options
    local OPTION_WITH_ARG_FOUND=""
    for option in "${@}"; do
        ((++LOOPS_COUNT))

        # if we have found option in previous loop, we write off the args of option
        #   and give name of the last option
        if [[ -n "${OPTION_WITH_ARG_FOUND}" ]]; then
            ARG=${option}
            option=${OPTION_WITH_ARG_FOUND}
        fi

        case "$option" in
            -e | --extension)
                # if we hove found this option in the previous loop;
                if [[ -n "${OPTION_WITH_ARG_FOUND}" ]]; then
                    extensionCommand "${ARG}"    # not released;
                    OPTION_WITH_ARG_FOUND=""
                else
                    OPTION_WITH_ARG_FOUND=${option}
                fi
                ;;
            -f | --from)
                # if we hove found this option in the previous loop;
                if [[ -n "${OPTION_WITH_ARG_FOUND}" ]]; then
                    fromCommand "${ARG}"    # not released;
                    OPTION_WITH_ARG_FOUND=""
                else
                    OPTION_WITH_ARG_FOUND=${option}
                fi
                ;;
            -h | --help)
                helpCommand
                ;;
            -r | --recursion)
                echo "Hello recursion!"
                ;;
            -t | --to)
                # if we hove found this option in the previous loop;
                if [[ -n "${OPTION_WITH_ARG_FOUND}" ]]; then
                    toCommand "${ARG}"
                    OPTION_WITH_ARG_FOUND=""
                else
                    OPTION_WITH_ARG_FOUND=${option}
                fi
                ;;
        esac
    done
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
    checkOptions "${@}"
    
    echo "DATADIR = ${DATADIR}"
    echo "PKG_MOVING_ROOT = ${PKG_MOVING_ROOT}"
    echo "MOVING_FILE_EXTENSION = ${MOVING_FILE_EXTENSION}"
}

test "$@"