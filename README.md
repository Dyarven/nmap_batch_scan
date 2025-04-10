# :green_book: Bash scripts

[![Star this repo](https://img.shields.io/github/stars/Dyarven/bash-scripts?style=social)](https://github.com/Dyarven/bash-scripts/stargazers)
[![Follow me](https://img.shields.io/github/followers/Dyarven?style=social)](https://github.com/Dyarven)
[![License](https://img.shields.io/github/license/Dyarven/bash-scripts)](https://github.com/Dyarven/bash-scripts/blob/main/LICENSE)

Bash scripts for task automation, network discovery, deploying configurations... etc. Also contains some QoL stuff and personal projects.

## Nmap batch scanner
Made with nmap to quickly check for open ports on a list of IPs provided via text file with multithreading support and a progression bar.

### Run the Script
```bash
# Run as sudo (some commands require root to make changes)
# Provide the file, the port to scan and the cpu threads your machine can handle:
./nmap_batch_scanner.sh targets.file 443 8
```


## PostgreSQL log archiver
Keep postgresql log files clean and tidy. Archives and compresses files that are two months old or more, by month-year so that you keep the last 60 days of logs easily accessible and the rest are stored efficiently.
Before setting this up check your postgresql log rotation config. This script is nice to have if you use a tool like Graylog where logs local to the machine are only accessed during disaster recovery or post disaster forensics, so you don't get lost in logs.

### Run the Script
```sql
# Check your log rotation config beforehand to see if it's set up correctly
SELECT name, setting FROM pg_settings WHERE name LIKE 'log_%';
```
```bash
# Configure a crontab for postgresql defining the frequency such as
30 04  *   *   *     /var/lib/postgresql/scripts/postgresql_log_archiver.sh

```
