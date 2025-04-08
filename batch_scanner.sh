#!/bin/bash

filename="$1"
port="$2"
threads=8  # system threads
output_file="result.txt"
temp_dir=$(mktemp -d)

echo "Running nmap, this might take a while..."

# Use xargs to handle batching and parallel execution
xargs -a "$filename" -L 100 -P "$threads" -I {} sh -c '
    ips=$(echo {} | tr " " ",")
    result=$(nmap --host-timeout 30s -T4 -n -p "$0" -oG - "$ips" 2>/dev/null)
    echo "$result" | awk '\''/open/ {gsub(/[()]/,"",$2); print $2}'\'' >> "$1"/temp.$$
' "$port" "$temp_dir"

# Combine results and clean up
cat "$temp_dir"/* >> "$output_file"
rm -rf "$temp_dir"

echo "finished scanning IP list"
