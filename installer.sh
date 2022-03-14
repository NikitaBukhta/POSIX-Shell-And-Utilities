#!/bin/sh

. fileEditor.sh

# have a mistake. Just to fix it
makeChanges()
{
    while :
        do
        # output current installing settings;
        echo "Current settings:"
        cat .my-settings
        echo "-------------------------"

        # Does customer want to change something in default settings?
        printf "Do you want to make some changes? [y/n]\nEnter: "
        read -r ANSWER
        case $(echo "${ANSWER}" | tr '[:upper:]' '[:lower:]') in
            y)
                printf "What do you want to change?\n1 - PKG_INSTALL_ROOT\n0 - cancel\nEnter: "
                read -r CHANGE_MODE

                # What does he / she want to change?
                case "$CHANGE_MODE" in
                    1)
                        printf "Please select folder (from home directory):\n"
                        read -r NEW_PKG_INSTALL_ROOT

                        # foolproofing (if this directory is exists);
                        if [ -d "${HOME}/${NEW_PKG_INSTALL_ROOT}" ]; then
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
}

makeNewAppDir()
{
    echo "Making new directory..."

    # getting data from .my-setting;
    PKG_INSTALL_ROOT=$(cut -d "=" -f2- <<< "$(grep PKG_INSTALL_ROOT= .my-settings)")
    APP_NAME=$(cut -d "=" -f2- <<< "$(grep APP_NAME= .my-settings)")

    mkdir "${PKG_INSTALL_ROOT}/${APP_NAME}"

    echo "Directory has been made successfully!"
}

# $1 - archive name
# $2 - where to install
# $3 - application name (not required)
install()
{
    if [ "${#}" -lt 3 ]; then
        exit 1
    fi

    makeNewAppDir
    echo "Installing..."
    tar xvf "${1}" -C "${2}/${3}"
    echo "${3} has been installed!"
}

installation_menu()
{
    # gettting data from .my-setting;
    ARCHIVE_NAME=$(cut -d "=" -f2- <<< "$(grep ARCHIVE_NAME= .my-settings)")
    PKG_INSTALL_ROOT=$(cut -d "=" -f2- <<< "$(grep PKG_INSTALL_ROOT= .my-settings)")
    APP_NAME=$(cut -d "=" -f2- <<< "$(grep APP_NAME= .my-settings)")

    if [ ! -d "${PKG_INSTALL_ROOT}/${APP_NAME}" ]; then
        install "${ARCHIVE_NAME}" "${PKG_INSTALL_ROOT}" "${APP_NAME}"
    else
        while :
        do
            printf "Are you sure you want to reload the app? [y/n]\nEnter: "
            read -r ANSWER

            case $(echo "${ANSWER}" | tr '[:upper:]' '[:lower:]') in
                y)
                    remove
                    install "${ARCHIVE_NAME}" "${PKG_INSTALL_ROOT}" "${APP_NAME}"
                    break
                    ;;
                n)
                   exit 1
                    ;;
            esac
        done
    fi
}

remove()
{
    PKG_INSTALL_ROOT=$(cut -d "=" -f2- <<< "$(grep PKG_INSTALL_ROOT= .my-settings)")
    APP_NAME=$(cut -d "=" -f2- <<< "$(grep APP_NAME= .my-settings)")

    if [ -d "${PKG_INSTALL_ROOT}/${APP_NAME}" ]; then
        echo "removing..."
        rm -r "${PKG_INSTALL_ROOT:?}/${APP_NAME:?}"
        echo "removing successful!"
    else
        echo "You have nothing to install"
    fi
}

main()
{
    printf "What do you want to do?\n\t1 - install app\n\t2 - remove app\n\t0 - exit\nEnter: "
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
}

main