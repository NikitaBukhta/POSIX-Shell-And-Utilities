#!/bin/bash

# where is our script contains;
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. "${SCRIPT_DIR}/settingEditor.sh"

# Display error of last command on the screen
#
# $1 - error message
# $2 - exit with that error code
#
# return error number
function checkForErros
{
    if [ $? -ne 0 ]; then
        echo "Error ${?}: ${1}"
        exit ${2}
    fi    
    
    return 0
}

# There user can choose 
function installation_menu()
{
    makeChangesMenu

    if [ ! -d "${PKG_INSTALL_ROOT}/${APP_NAME}" ]; then
        mkdir "${PKG_INSTALL_ROOT}/${APP_NAME}"
        install "${PKG_INSTALL_ROOT}/${APP_NAME}" "${APP_NAME}"
    else
        while :
        do
            printf "Are you sure you want to reload the app? [y/n]\nEnter: "
            read -r ANSWER

            case $(echo "${ANSWER}" | tr '[:upper:]' '[:lower:]') in
                y)
                    remove
                    mkdir "${PKG_INSTALL_ROOT}/${APP_NAME}"
                    install "${PKG_INSTALL_ROOT}/${APP_NAME}" "${APP_NAME}"
                    break
                    ;;
                n)
                   exit 0
                    ;;
            esac
        done
    fi
}

# make changes in .my-settings.txt if user want that
function makeChangesMenu()
{
    while :
        do
        # output current installing settings;
        echo "---------------------------------------------------------------------------"
        echo "Current settings:"
        cat .my-settings.txt
        echo "---------------------------------------------------------------------------"

        # Does customer want to change something in default settings?
        printf "Do you want to make some changes? [y/n]\nEnter: "
        read -r ANSWER
        case $(echo "${ANSWER}" | tr '[:upper:]' '[:lower:]') in
            y)
                printf "What do you want to change?\n1 - PKG_INSTALL_ROOT\n0 - cancel\nEnter: "
                local CHANGE_MODE
                read -r CHANGE_MODE

                # What does he / she want to change?
                case "$CHANGE_MODE" in
                    1)
                        printf "Please select folder (from home directory):\n"
                        read -r NEW_PKG_INSTALL_ROOT

                        # foolproofing (if this directory is exists);
                        if [ -d "${HOME}/${NEW_PKG_INSTALL_ROOT}" ]; then
                            PKG_INSTALL_ROOT=${NEW_PKG_INSTALL_ROOT}
                            changeMySettings .my-settings PKG_INSTALL_ROOT "${NEW_PKG_INSTALL_ROOT}"
                        else
                            echo "This folder name is not exists!"
                        fi
                        ;;
                    *)
                        break
                        ;;
                esac
                ;; 
            *)
                break
                ;;
        esac
    done

    return 0
}

# change to the current data the next VARs:
#   PATH
#   INST_DATADIR
function updateSettings()
{
    changeMySettings ".my-settings.txt" PATH "${SCRIPT_DIR}"
    changeMySettings ".my-settings.txt" INST_DATADIR "${SCRIPT_DIR}"

    return 0
}

# install application to certain directory;
# $1 - where to install;
# $2 - application name;
install()
{
    if [ "${#}" -lt 2 ]; then
        exit 1
    fi

    gcc ./*c -o "$2"
    checkForErros "GCC can' compile the file. Check the error number on the net" 2
    mv "$2" "$1"
    checkForErros "Directory mb is not exists" 3

    return 0
}

# remove application
function remove()
{
    if [ -d "${PKG_INSTALL_ROOT}/${APP_NAME}" ]; then
        echo "Removing application"
        rm -r "${PKG_INSTALL_ROOT:?}/${APP_NAME:?}"
        echo "Removing successful!"
        return 0
    else
        echo "You have nothing to remove"
        return 1
    fi
}

function main()
{
    updateSettings

    PKG_INSTALL_ROOT=$(cut -d "=" -f2- <<< "$(grep PKG_INSTALL_ROOT= .my-settings.txt)")
    APP_NAME=$(cut -d "=" -f2- <<< "$(grep APP_NAME= .my-settings.txt)")

    printf "What do you want to do?\n\t1 - install app\n\t2 - remove app\n\t0 - exit\nEnter: "
    local ANSWER
    read -r ANSWER

    while :
    do
        case "$ANSWER" in
            1)
                installation_menu
                break
                ;;
            2)
                remove
                break
                ;;
            *)
                exit 0
                ;;
        esac
    done

    exit ${?}
}

main