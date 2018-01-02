# EasyS3

A simple bash script to take automated offsite backup of sites created with EasyEngine

## How to Use this script

1. Create backup.sh in your syncked directory:
`vi /home/youruser/backups/backup.sh`
2. Paste this script in to this opend file: press i and then click with right mouse button
3. Save and close this file: press ESC, now write wq, press ENTER

- OR-
Simply copy this script from GitHub
`mkdir -p /home/youruser/backups/ && wget -O /home/youruser/backups/backup.sh http://www.github.com/url`

4. Make this script executable:
`chmod +x /home/youruser/backups/backup.sh`

5. If you want to exclude certain files/directories, create a file called "exclude.txt" inside the backups directory
6. Add pattern/path for all excluded files/directories in this file (one per line) and save it
7. Run this script to start backup immidiately

- OR - 
8. Set cron job to automate the backup: /home/youruser/backups/backup.sh >/dev/null 2>&1
