#!/bin/sh

# function change or add variable value
# $1 - name of file
# $2 - name of variable
# $3 - value of variable
changeMySettings()
{
    # if we don't have enugh args
    if [ "$#" -lt 3 ]; then
        exit 1
    fi

    # Change .my-settings
    CURRENT_LINE_NUMBER=$(perl -lne "print $. if /${2}=/" "${1}")
    CURRENT_SETTING_LINE=$(grep "${2}=" "${1}")
    #echo "$string"
    #printf "\n\n\n"

    if [ "${CURRENT_LINE_NUMBER}" = "" ]; then
        echo "${2}=${3}" >> "${1}"
    else
        sed -i '' -e "s/${CURRENT_SETTING_LINE}/${2}=${3}/" "${1}"
    fi
}