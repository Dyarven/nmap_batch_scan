#!/bin/bash

filename="$1"
port="$2"
threads=8
outfile="result.txt"
temp_dir=$(mktemp -d)

total_ips=$(wc -l < "$filename")

echo "Running nmap scan for port $port across $total_ips IPs..."

# Progress bar
pv -l -s "$total_ips" "$filename" | xargs -L 100 -P "$threads" -I {} sh -c '
    ips=$(echo {} | tr " " ",")
    result=$(nmap --host-timeout 30s -T4 -n -p "$0" -oG - "$ips" 2>/dev/null)
    echo "$result" | awk '\''/open/ {gsub(/[()]/,"",$2); print $2}'\'' >> "$1"/temp.$$
' "$port" "$temp_dir"

cat "$temp_dir"/* >> "$outfile"
rm -rf "$temp_dir"
echo "Scan completed. Results saved to $outfile"
