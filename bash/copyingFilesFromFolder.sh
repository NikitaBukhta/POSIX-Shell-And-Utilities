#!/bin/bash

DATADIR=${PWD}                                  # files location
PKG_MOVING_ROOT="${HOME}/Documents/my-headers"  # moving location
MOVING_FILE_EXTENSION=".h"                      # files extension
RECURSIVE=false                                 # Must we check every subdir?

# Copy all * .h files to `my-headers` directory.
# $1 - from which folder directory we get files
# $2 - to which directory we copy files
# $3 - which files extension we copy
#
# return 1 if file isn't $3
function copyFiles()
{
    # if that is file
    if [ ! -d "$1" ]; then
        return 3
    fi

    cd "${1}" || return 2

    if [[ "${RECURSIVE}" = true ]]; then
        for folder in *; do
            if [[ -d "$folder" ]]; then
                # go to the subdir and continue checking
                copyFiles "${1}/${folder}" "${2}" "${3}"
                cp ./*"${3}" "${2}"
                cd ..
            fi
        done
    else
        cp ./*"${3}" "${2}"
    fi

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
#
# return 1 if we cann't open the dir
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
                cd "${HOME}" || return 1
                continue
            elif [[ ! -e $folder ]]; then
                HOME_DIRECTORY_CHECKED=1
            fi
        fi

        cd "${folder}" || return 1
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
    echo "RECURSIVE=${RECURSIVE}"
    echo "    That means we check all subdir in DATADIR or not"
    echo "-----------------------------------"
    echo "Options:"
    echo "    -e -- file extension. File with which extension we want to move"
    echo "    --extension -- the same as -e"
    echo "    -f -- from which directory you want to copy files"
    echo "    --from - the same as -f"
    echo "    -h -- output script brief"
    echo "    --help -- the same as -h"
    echo "    -r -- check subdirectories for containing files. Can be true or false."
    echo "    --recursion -- the same as -r"
    echo "    -t -- to which directory you want to copy files. If this directory is not exits, it will be created"
    echo "    --to - the same as -t"
    echo "-----------------------------------"
    echo "Errors:"
    echo "    1 - cannot open the directory."
    echo "    2 - cannot change recursive mode"
    echo "    3 - you want to copy from something that isn't directory"
}

# set new RECURSIVE movde
#
# $1:
#   true - check all subdir
#   false - don't check
#   other return error
function recursionCommand()
{
    local IS_RECURSIVE
    IS_RECURSIVE=$(echo -e "${1}" | tr '[:upper:]' '[:lower:]')
    
    if [[ "${IS_RECURSIVE}" = true || "${IS_RECURSIVE}" = false ]]; then
        RECURSIVE="${IS_RECURSIVE}"
    else
        echo "Cannot change recursion mode."
        return 2
    fi
}

# set new PKG_MOVING_ROOT value
#
# $1 - directory you want to set
#
# return 1 if we cann't open the dir
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

        cd "${folder}" || return 1
    done
    
    PKG_MOVING_ROOT=${1}
}

# check all options from all args to change standart settings;
#
# $[unpair_number] - option ($1, $3...)
# $[pair_number] - option_arg ($2, $4...)
function checkOptions()
{
    local returnCode=0
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
                # if we hove found this option in the previous loop;
                if [[ -n "${OPTION_WITH_ARG_FOUND}" ]]; then
                    recursionCommand "${ARG}"    # not released;
                    OPTION_WITH_ARG_FOUND=""
                else
                    OPTION_WITH_ARG_FOUND=${option}
                fi
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

    return $returnCode
}

function main()
{
    checkOptions "${@}"

    # create new dir if user don't change standart;
    toCommand "${PKG_MOVING_ROOT}"
    
    echo "Current settings:"
    echo "DATADIR = ${DATADIR}"
    echo "PKG_MOVING_ROOT = ${PKG_MOVING_ROOT}"
    echo "MOVING_FILE_EXTENSION = ${MOVING_FILE_EXTENSION}"
    echo "Recursive: ${RECURSIVE}"

    copyFiles "$DATADIR" "$PKG_MOVING_ROOT" "$MOVING_FILE_EXTENSION"
}

main "$@"