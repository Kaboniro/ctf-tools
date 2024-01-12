#!/bin/bash

# Check if any arguments have been supplied
if [ -z "$1" ]
then
    echo "Usage: ./recon.sh <IP>"
    exit 1
fi

# Run nmap
printf "\n.........NMAP.........\n" > results
echo "Running NMAP......."
nmap -T4 -sC -sV -Pn "$1" | tail -n +5 | head -n -3 >> results

# Check for open HTTP ports
while read -r line
do
    if [[ $line == *open* && $line == *http* ]]
    then
        echo "Running GoBuster......."
        gobuster dir -u "$1" -w /usr/share/dirb/wordlists/common.txt -q -r -c 200,204,301,302,307,308 -v  > temp1

        echo "Running WhatWeb......."
        whatweb "$1" -v > temp2
    fi
done < results

read -p "Scan for known vulnerabilities.....(y/n)" ans
if [[ $ans == "y" ]]
then
    nikto -h "$1" | head -n -3 > temp3
fi

if [ -e temp1 ]
then
    echo -e "\n..........GOBUSTER........\n" >> results
    cat temp1 >> results
    rm temp1
fi

if [ -e temp2 ]
then
    echo -e "\n..........WHATWEB........\n" >> results
    cat temp2 >> results
    rm temp2
fi

if [ -e temp3 ]
then
    echo -e "\n..........NIKTO........\n" >> results
    cat temp3 >> results
    rm temp3
fi

cat results
