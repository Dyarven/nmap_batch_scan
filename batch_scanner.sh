#!/bin/bash
filename="$1"
port="$2"
threads=8
output_file="result.txt"
temp_dir=$(mktemp -d)

total_ips=$(wc -l < "$filename")

echo "Running nmap scan for port $port across $total_ips IPs..."

pv -l -s "$total_ips" "$filename" | xargs -n 100 -P "$threads" sh -c '
    port="$1"
    temp_dir="$2"
    shift 2  # Remove first two arguments (port and temp_dir)
    
    # Run nmap with IPs as separate arguments
    result=$(nmap --host-timeout 30s -T4 -n -p "$port" -oG - "$@" 2> "$temp_dir"/nmap_errors.log)
    
    # Parse results
    echo "$result" | awk '\''/open/ {gsub(/[()]/,"",$2); print $2}'\'' >> "$temp_dir"/temp.$$
' _ "$port" "$temp_dir"

cat "$temp_dir"/temp.* > "$output_file"
echo -e "\nScan errors:"
cat "$temp_dir"/nmap_errors.log
rm -rf "$temp_dir"

echo -e "\IPs with port $port open:"
cat "$output_file"
