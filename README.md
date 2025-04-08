# Nmap batch scanner

[![Star this repo](https://img.shields.io/github/stars/Dyarven/nmap_batch_scan?style=social)](https://github.com/Dyarven/haproxy-socat-swiss-knife/stargazers)
[![Follow me](https://img.shields.io/github/followers/Dyarven?style=social)](https://github.com/Dyarven)
[![License](https://img.shields.io/github/license/Dyarven/nmap_batch_scan)](https://github.com/Dyarven/haproxy-socat-swiss-knife/blob/main/LICENSE)

Bash script with nmap made to quickly check for open ports on a list of IPs provided via text file with multithreading support and a progression bar.

## Requirements
- NMAP and a  dream (or a necessity to check for open ports)


## Usage
### Run the Script
```bash
# Run as sudo (some commands require root to make changes)
# Provide the file, the port to scan and the cpu threads your machine can handle:
bash batch_scanner.sh targets.file 443 8
```

