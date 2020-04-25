#!/bin/bash

# Goes through all jpeg files in selected directory, grabs date from each
# and sorts them into subdirectories according to the date
# Creates subdirectories corresponding to the dates as necessary.

echo "Organizing Pictures from $1 to $2"

cd $1

shopt -s globstar # Enable recursive glob
for fil in ./**/*.{jpg,JPG}
do
    datepath="$(exiftool -DateTimeOriginal $fil | awk '{print $4}' | sed s%:%%g | sed 's%\(^[0-9]\{4\}\)%\1/\1%g')"
    echo "Image File: $fil"
    echo "Date Path: $2/$datepath"

    if ! test -e "$datepath"; then
        mkdir -pv "$2/$datepath"
    fi

    cp -uvp $fil "$2/$datepath"
done