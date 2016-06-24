#!/bin/bash

# Script to process .png into an .icns file
# .png to process must be 1024x1024 at 144 dpi or this fails hard.

# Has a file actually been submitted?

if [ "$1" = "" ];
then
		echo "Usage: ./createicns.sh <full path to source png>"
		exit 1
fi

# Work out file, path and extension info

fullpath="$1"
path=$( dirname "$1" )
ext=${1##*.}
file=$( basename "$1" ".$ext" )

# Is this a .png file?

if [ "$ext" != "png" ];
then
	echo "Please use a .png file with this utility"
	exit 1
fi

# Is the .png file the correct size and dpi?

dpix=$( sips --getProperty dpiWidth "$fullpath" | awk '{if (NR =2) print $2 }' | cut -d . -f 1 )
dpiy=$( sips --getProperty dpiHeight "$fullpath" | awk '{if (NR =2) print $2 }' | cut -d . -f 1 )
pixelx=$( sips --getProperty pixelWidth "$fullpath" | awk '{if (NR =2) print $2 }' | cut -d . -f 1 )
pixely=$( sips --getProperty pixelHeight "$fullpath" | awk '{if (NR =2) print $2 }' | cut -d . -f 1 )

if [ "$dpix" != "144" ] || [ "$dpiy" != "144" ] || [ "$pixelx" != "1024" ] || [ "$pixely" != "1024" ];
then
	echo "Your .png file must be 1024x1024 resolution at 144 dpi."
	exit 1
fi

# Create the icns file

mkdir "$path"/"$file".iconset

sips -z 16 16     "$fullpath" --out "$path"/"$file".iconset/icon_16x16.png
sips -z 32 32     "$fullpath" --out "$path"/"$file".iconset/icon_16x16@2x.png
sips -z 32 32     "$fullpath" --out "$path"/"$file".iconset/icon_32x32.png
sips -z 64 64     "$fullpath" --out "$path"/"$file".iconset/icon_32x32@2x.png
sips -z 128 128   "$fullpath" --out "$path"/"$file".iconset/icon_128x128.png
sips -z 256 256   "$fullpath" --out "$path"/"$file".iconset/icon_128x128@2x.png
sips -z 256 256   "$fullpath" --out "$path"/"$file".iconset/icon_256x256.png
sips -z 512 512   "$fullpath" --out "$path"/"$file".iconset/icon_256x256@2x.png
sips -z 512 512   "$fullpath" --out "$path"/"$file".iconset/icon_512x512.png
cp "$fullpath" "$path"/"$file".iconset/icon_512x512@2x.png

iconutil --convert icns "$path"/"$file".iconset

rm -R "$path"/"$file".iconset

exit 0
