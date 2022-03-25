#!/bin/bash

# set standard values for:
#   PATH                - where is bash scripts;
#   APP_NAME            - name of Application;
#   INST_DATADIR        - app archive location;
#   PKG_INSTALL_ROOT    - where we must to install application;
setStandartSettings()
{
    # to get dir of current file;
    # Answer I have found there:
    #   https://stackoverflow.com/questions/59895/how-can-i-get-the-source-directory-of-a-bash-script-from-within-the-script-itsel
    local SCRIPT_DIR
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    local INST_DATADIR
    INST_DATADIR="${SCRIPT_DIR}/.."
    changeMySettings "${SCRIPT_DIR}/.my-settings.txt" PATH "${SCRIPT_DIR}"
    changeMySettings "${SCRIPT_DIR}/.my-settings.txt" APP_NAME "POSIX Application"
    changeMySettings "${SCRIPT_DIR}/.my-settings.txt" INST_DATADIR "${INST_DATADIR}"
    changeMySettings "${SCRIPT_DIR}/.my-settings.txt" PKG_INSTALL_ROOT "${HOME}/Documents"
}

# function change or add variable value;
# $1 - name of file;
# $2 - name of variable;
# $3 - value of variable;
changeMySettings()
{
    # if we don't have enugh args;
    if [ "$#" -lt 3 ]; then
        exit 1
    fi

    # Change .my-settings;
    # where is out line;
    local CURRENT_LINE_NUMBER
    local CURRENT_SETTING_LINE
    if [ -e "${1}" ]; then
        CURRENT_LINE_NUMBER=$(perl -lne "print $. if /${2}=/" "${1}")
        CURRENT_SETTING_LINE=$(grep "${2}=" "${1}")
    fi
    
    if [ -z "${CURRENT_LINE_NUMBER}" ]; then
        echo "${2}=${3}" >> "${1}"
    else
        # firstly, make backup file .bak and remove that;
        # Then we write changes to ${1} file save them;
        sed -i.bak -e "s:${CURRENT_SETTING_LINE}:${2}=${3}:" "${1}" && rm "${1}.bak"
    fi
}