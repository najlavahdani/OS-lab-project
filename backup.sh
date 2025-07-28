#!/bin/bash
#part1S
# checking the number of arguments
if [ "$#" -ne 4 ]; then 
	echo "Usage: $0 <search_path> <file_extension> <backup_directory> <retention_days>"
	exit 1
fi

# getting inputs
SEARCH_PATH="$1"
FILE_EXTENSION="$2"
BACKUP_DIR="$3"
RETENTION_DAYS="$4"

# start time for reporting
START_TIME=$(date +%s)

# checking for the existence of the search path
if [ ! -d "$SEARCH_PATH" ]; then
	echo "Error: the path '$SEARCH_PATH' doesnt exist."
	exit 1
fi 

# if the backup path does not exist,S creat it
if [ ! -d "$BACKUP_DIR" ]; then
	mkdir -p "$BACKUP_DIR"
	echo "backup folder created at: $BACKUP_DIR"
fi

# show summary information
echo "SEARCH PATH: $SEARCH_PATH"
echo "FILE EXTENSION: $FILE_EXTENSION"
echo "BACKUP DIRECTORY: $BACKUP_DIR"
echo "RETENTION DAYS: $RETENTION_DAYS"

# delete the previous backup.conf file if it exists
CONF_FILE="backup.conf"
if [ -f "$CONF_FILE" ]; then 
	rm "$CONF_FILE"
fi

# search and save file paths in backup.conf
find "$SEARCH_PATH" -type f -name "*$FILE_EXTENSION" > "$CONF_FILE"
echo "List of files to backup saved to $CONF_FILE"

# part2
# create a timestamped subdirectory inside the backup directory
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
DEST_DIR="$BACKUP_DIR/backup_$TIMESTAMP"
mkdir -p "$DEST_DIR"

# copy files to the new backup directory
while IFS= read -r file_path; do
	# preserve directory structure
	RELATIVE_PATH="${file_path#$SEARCH_PATH/}"
	DEST_PATH="$DEST_DIR/$RELATIVE_PATH"
    	mkdir -p "$(dirname "$DEST_PATH")"
	cp "$file_path" "$DEST_PATH"
done < "$CONF_FILE"
echo "Backup completed and saved to $DEST_DIR"


#part3
# compressing the backup folder with tar and gzip
ARCHIVE_NAME="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"
tar -czf "$ARCHIVE_NAME" -C "$BACKUP_DIR" "backup_$TIMESTAMP"

echo "Backup archive created at: $ARCHIVE_NAME"

# delete uncompressed folder after creating archive
rm -rf "$DEST_DIR"
echo "Uncompressed backup folder removed."



#part4
LOG_FILE="backup.log"

# calculating the end time and duration of the operation
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

# checking the success or failure of compression
if [ -f "$ARCHIVE_NAME" ]; then
    BACKUP_SIZE=$(du -h "$ARCHIVE_NAME" | cut -f1)
    STATUS="SUCCESS"
else
    BACKUP_SIZE="0"
    STATUS="FAILURE"
fi











