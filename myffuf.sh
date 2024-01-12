#!/bin/bash
requests_per_minute=120
seconds_per_request=$((60 / $requests_per_minute))

# Prompt the user for the target URL
read -p "Enter the target URL (e.g., http://example.com/FUZZ): " target_url

# Run ffuf with rate limiting and user-specified target URL
for ((i = 1; i <= 5; i++)); do
	ffuf -u "${target_url}" -w /usr/share/dirb/wordlists/common.txt 

# Sleep to limit the rate
sleep $seconds_per_request
done
