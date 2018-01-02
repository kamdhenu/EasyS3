#!/bin/bash
#set -x
#trap read debug
#@author                kamdhenu
#@version               0.1.0

####### How to Use this script #######
# 1. Install and configure s3cmd on your server
#		$ apt-get install s3cmd
#		$ s3cmd --configure
# 2. Create an unique directory on your server to store backup files: mkdir ~/backups/
# 3. Create backup.sh and paste this script in to it: vi ~/backups/backup.sh
#    OR Download it from GitHub: wget -O ~/backups/backup.sh https://raw.githubusercontent.com/kamdhenu/EasyS3/master/backup.sh 
# 4. Make script executable: chmod +x ~/backups/backup.sh
# 5. If you want to exclude certain files/directories, create a file called "exclude.txt"
# 6. Add pattern/path for all excluded files/directories in this file (one per line) and save it
# 7. Set cron job to automate the backup: /root/backups/backup.sh >/dev/null 2>&1
# => To download your folder from s3 run: s3cmd get --recursive s3://your_s3_bucket/your_backup_dir/
#######################################


s3Bucket=your_s3_bucket/your_backup_dir/ # Your s3 bucket name
rootDir=/var/www
backupDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd "${rootDir}" || logger -s "Error root directory: ${rootDir} does not exist" 2>> "${backupDir}/error.txt" exit
for dir in */
do
base=$(basename "$dir")
[[ $base =~ ^(22222|composer|html)$ ]] && continue
  if [ -f "${base}/ee-config.php" ]; then
    fileName=$base-$(date +"%Y-%m-%d")
	host=$(grep DB_HOST "${base}/ee-config.php" |cut -d "'" -f 4)
	username=$(grep DB_USER "${base}/ee-config.php" | cut -d "'" -f 4)
	password=$(grep DB_PASSWORD "${base}/ee-config.php" | cut -d "'" -f 4)
	dbName=$(grep DB_NAME "${base}/ee-config.php" |cut -d "'" -f 4)
	mysqldump -h "$host" -u "$username" -p"$password" "$dbName" | gzip > "${base}/$fileName.sql.gz"
	if [ -f "${backupDir}/exclude.txt" ]; then
		tar -czf "${fileName}.tar.gz" --exclude-from="${backupDir}/exclude.txt" "$dir"
	else
		tar -czf "${fileName}.tar.gz" "$dir"
	fi
	mv "${fileName}.tar.gz" "$backupDir"
	rm -f "${base}/$fileName.sql.gz"
	s3cmd --acl-private -m binary/octet-stream --delete-removed put "$backupDir/${fileName}.tar.gz" s3://"$s3Bucket"
	
  elif [ -f "${base}/wp-config.php" ]; then
    fileName=$base-$(date +"%Y-%m-%d")
	host=$(grep DB_HOST "${base}/wp-config.php" |cut -d "'" -f 4)
	username=$(grep DB_USER "${base}/wp-config.php" | cut -d "'" -f 4)
	password=$(grep DB_PASSWORD "${base}/wp-config.php" | cut -d "'" -f 4)
	dbName=$(grep DB_NAME "${base}/wp-config.php" |cut -d "'" -f 4)
	mysqldump -h "$host" -u "$username" -p"$password" "$dbName" | gzip > "${base}/$fileName.sql.gz"
	if [ -f "${backupDir}/exclude.txt" ]; then
		tar -czf "${fileName}.tar.gz" --exclude-from="${backupDir}/exclude.txt" "$dir"
	else
		tar -czf "${fileName}.tar.gz" "$dir"
	fi
	mv "${fileName}.tar.gz" "$backupDir"
	rm -f "${base}/$fileName.sql.gz"
	s3cmd --acl-private -m binary/octet-stream --delete-removed put "$backupDir/${fileName}.tar.gz" s3://"$s3Bucket"
	
  else
    fileName=$base-$(date +"%Y-%m-%d")
	if [ -f "${backupDir}/exclude.txt" ]; then
		tar -czf "${fileName}.tar.gz" --exclude-from="${backupDir}/exclude.txt" "$dir"
	else
		tar -czf "${fileName}.tar.gz" "$dir"
	fi
	mv "${fileName}.tar.gz" "$backupDir"
	rm -f "${base}/$fileName.sql.gz"
	s3cmd --acl-private -m binary/octet-stream --delete-removed put "$backupDir/${fileName}.tar.gz" s3://"$s3Bucket"

fi  
done

find "${backupDir}" -type f -name '*.tar.gz' -mtime +15 -delete
