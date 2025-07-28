#!/bin/bash

if [ "$#" -ne 4 ]; then 
	echo "Usage: $0 <search_path> <file_extension> <backup_directory> <retention_days>"
	exit 1
fi

SEARCH_PATH= "$1"
FILE_EXTENSION= "$2"
BACKUP_DIR= "$3"
RETENTION_DAYS= "$4"

if [ ! -d "$SEARCH_PATH" ]; then
	echo "Error: the path '$SEARCH_PATH' doesnt exist."
	exit 1
fi 


if [ ! -d "$BACKUP_DIR" ]; then
	mkdir -p "$BACKUP_DIR"
	echo "backup folder created at: $BACKUP_DIR"
fi


echo "SEARCH PATH: $SEARCH_PATH"
echo "FILE EXTENSION: $FILE_EXTENSION"
echo "BACKUP DIRECTORY: $BACKUP_DIR"
echo "RETENTION DAYS: $RETENTION_DAYS"
