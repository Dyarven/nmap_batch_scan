# :green_book: Bash scripts

[![Star this repo](https://img.shields.io/github/stars/Dyarven/bash-scripts?style=social)](https://github.com/Dyarvenbash-scripts/stargazers)
[![Follow me](https://img.shields.io/github/followers/Dyarven?style=social)](https://github.com/Dyarven)
[![License](https://img.shields.io/github/license/Dyarven/bash-scripts)](https://github.com/Dyarven/bash-scripts/blob/main/LICENSE)

Bash scripts for task automation, network discovery, deploying configurations... etc. Also contains some QoL stuff and personal projects.

## Nmap batch scanner
Bash script with nmap made to quickly check for open ports on a list of IPs provided via text file with multithreading support and a progression bar.

### Run the Script
```bash
# Run as sudo (some commands require root to make changes)
# Provide the file, the port to scan and the cpu threads your machine can handle:
./nmap_batch_scanner.sh targets.file 443 8
```

