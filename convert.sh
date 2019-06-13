#!/bin/bash

######################## Transcode the files using ... ########################
# vcodec="mp4v"
# acodec="mp4a"
# vb="1024"
# ab="128"
# mux="mp4"
infmt="aac"
outfmt="mp3"
acodec="mp3"
ab="128"
mux="mp3"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

###############################################################################

# Store path to VLC in $vlc
vlc="/Applications/VLC.app/Contents/MacOS/VLC"

# Sanity check
if ! command -pv "$vlc" >/dev/null 2>&1; then
    printf '%s\n' "Cannot find path to VLC. Abort." >&2
    exit 1
fi

for filename in $DIR/*.$infmt; do
    printf '%s\n' "=> Transcoding '$filename'... "
    "$vlc" -I dummy -q "$filename" \
       --sout "#transcode{acodec=\"$acodec\",ab=\"$ab\"}:standard{mux=\"$mux\",dst=\"${filename%.*}.$outfmt\",access=file}" \
       vlc://quit
    ls -lh "${filename%.*}.$outfmt"
    printf '\n'
done
