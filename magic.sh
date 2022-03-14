#!/bin/sh

. fileEditor.sh

# create archive of application folder;
createApplicationArchive()
{
    CURRENT_DATE=$(date +'%Y-%m-%d-%H-%M-%S')
    # make environment variables available to installation
    APP_NAME=$(basename "${PWD}")       # application name
    ARCHIVE_NAME="${APP_NAME}_${CURRENT_DATE}-cc.tar.gz"
    PKG_INSTALL_ROOT=${HOME}/Documents  # where we will install app

    changeMySettings .my-settings ARCHIVE_NAME "${ARCHIVE_NAME}"
    changeMySettings .my-settings APP_NAME "${APP_NAME}"
    changeMySettings .my-settings PKG_INSTALL_ROOT "${PKG_INSTALL_ROOT}"

    # Create an archive of this project;
    echo "Create a new archive..."
    tar -cvzf "${ARCHIVE_NAME}" ./*.*
    #cp installer.sh "../"
    tar -cvzf "../POSIX Shell And Utilities.tar.gz" "${ARCHIVE_NAME}" installer.sh fileEditor.sh ".my-settings"
    rm -r "${ARCHIVE_NAME}"

    echo "Archive has been created successfully!"
}

# find the first 20 occurrences of _asm in all .c files
findFirst20WordsInFiles()
{
    COUNT_OF_OCCURENCE=0    # how many occurences of specific word;
    WORD="_asm"
    # get name of every file with .c extension;
    for c_file in *.c
    do
        # get count of words of $WORD and write of in our variable;
        COUNT_OF_OCCURENCE=$((COUNT_OF_OCCURENCE+$(grep -c $WORD "$c_file")))
        
    if [ "$COUNT_OF_OCCURENCE" -ge 0 ]; then break; fi
    done
}

# move files with specific extensions to specific folder;
# there is all .h files to "my-headers" folder;
moveFilesToFolder()
{
    HEADERS_FOLDER_NAME="my-headers"
    for h_file in *.h
    do
        #if one *.h file exists
        if [ -e "$h_file" ]; then
            # check if folder is exist in specific directory;
            # if not we create a folder;
            if [ ! -d "$HEADERS_FOLDER_NAME" ]; then
                mkdir $HEADERS_FOLDER_NAME
            fi

            # copy all header file to this folder;
            cp ./*.h $HEADERS_FOLDER_NAME
            
            break
        fi
    done
}

# output all extensions in sorted view without repeats;
outputAllFolderExtensions()
{
    echo "All extension files: "
    # Ouput all files' extension without repeat;
    # I have found the answer there:
    #   https://stackoverflow.com/questions/1842254/how-can-i-find-all-of-the-distinct-file-extensions-in-a-folder-hierarchy
    for f in *.*; do echo "${f##*.}"; done | sort -u
}

createApplicationArchive