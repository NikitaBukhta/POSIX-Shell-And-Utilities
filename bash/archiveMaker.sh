#!/bin/bash

# where is our script contains
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. "${SCRIPT_DIR}/settingEditor.sh"

# create archive of application folder;
createApplicationArchive()
{
    # if file isn't exists or is empty, just fill that and/or create
    if [ ! -s "{$SCRIPT_DIR}/.my-settings.txt" ]; then
        setStandartSettings;
    fi

    CURRENT_DATE=$(date +'%Y-%m-%d-%H-%M-%S')
    # make environment variables available to installation
    local APP_NAME
    local ARCHIVE_NAME
    APP_NAME=$(cut -d "=" -f2- <<< "$(grep APP_NAME= "${SCRIPT_DIR}"/.my-settings.txt)")
    INST_DATADIR=$(cut -d "=" -f2- <<< "$(grep INST_DATADIR= "${SCRIPT_DIR}"/.my-settings.txt)")
    ARCHIVE_NAME="${APP_NAME}_${CURRENT_DATE}-cc.tar.gz"
    
    # set new archive name
    changeMySettings "${SCRIPT_DIR}/.my-settings.txt" ARCHIVE_NAME "${ARCHIVE_NAME}"

    # Create an archive of our application;
    echo "Create a new archive..."
    # go to directory where our project;
    cd "${INST_DATADIR}" || exit 1
    
    # and make installation directory
    INST_DIR_NAME="${APP_NAME} installation dir"
    if [ -d "${INST_DIR_NAME}" ]; then
        rm -r "${INST_DIR_NAME="installation"}"
    fi
    mkdir "${INST_DIR_NAME}"

    # copy all files to root project directory to make a archive
    INSTALLER_FILES_DIR="src/*.c bash/installer.sh bash/.my-settings.txt bash/settingEditor.sh bash/README"
    for FILE in $INSTALLER_FILES_DIR; do
        cp "${FILE}" "${INST_DIR_NAME}/"
    done
    zip "../${ARCHIVE_NAME}" -r "${INST_DIR_NAME}"
    
    rm -r "${INST_DIR_NAME}"

    echo "Archive has been created successfully!"
}

main()
{
    createApplicationArchive
}

main