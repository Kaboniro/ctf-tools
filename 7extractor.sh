#!/bin/bash
passwordlist="/path to password list"
outdir="/next"
cat "$passwordlist" | tr -d '\r' | while IFS= read -r PW 
do 
    if [[ $(7z x -p"$PW" "$1" 2>&1 | grep --count "ERROR") == 0 ]] 
    then
        echo "$PW" 
        7z x -p"$PW" -o"$outdir" -y "$1" 
        exit 0
    fi
done
