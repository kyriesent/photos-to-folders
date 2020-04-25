#!/bin/bash

# Goes through all jpeg files in current directory, grabs date from each
# and sorts them into subdirectories according to the date
# Creates subdirectories corresponding to the dates as necessary.

# Only works on photos taken on Apple Hardware

echo "Organizing ONLY APPLE Pictures from $1 to $2"

shopt -s globstar # Enable recursive glob

cd "$1"

export dest="$2"

function copyOrganized {
    fil="$*"
    echo "Image File: $fil"
    deviceMake=$(exiftool -Make "$fil" | awk '{print $3}')
    if [ "$deviceMake" != "Apple" ]; then
        echo "Not an Apple Photo, Skipping"
        return
    fi

    datepath=$(exiftool -DateTimeOriginal "$fil" | awk '{print $4}' | sed s%:%%g | sed 's%\(^[0-9]\{4\}\)%\1/\1%g')
    echo "Date Path: $dest/$datepath"

    if ! test -e "$datepath"; then
        mkdir -pv "$dest/$datepath"
    fi

    cp -uvp "$fil" "$dest/$datepath"
}

export -f copyOrganized

find . -name '*.jpg' -print0 | xargs -0 -I {} bash -c "copyOrganized {}"

# for fil in "find . -name '*.jpg'"  # Also try *.JPG
# do
#     deviceMake="$(exiftool -Make $fil | awk '{print $3}')"
#     echo "Image File: $fil"
#     if [ "$deviceMake" != "Apple" ]; then
#         echo "Not an Apple Photo, Skipping"
#         continue
#     fi

#     datepath="$(exiftool -DateTimeOriginal $fil | awk '{print $4}' | sed s%:%%g | sed 's%\(^[0-9]\{4\}\)%\1/\1%g')"
#     echo "Date Path: $2/$datepath"

#     if ! test -e "$datepath"; then
#         mkdir -pv "$2/$datepath"
#     fi

#     cp -uvp $fil "$2/$datepath"
# done