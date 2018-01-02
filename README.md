# EasyS3

A simple bash script to take automated offsite backup of sites created with [EasyEngine](https://github.com/EasyEngine/easyengine)

## How to Use this script

1. First of all install and configure [s3cmd](https://github.com/s3tools/s3cmd) on your server
```
apt-get install s3cmd
s3cmd --configure
```

2 Create backup.sh in your /root/backups directory:
```
vi ~/backups/backup.sh
```
* Paste this script in to this opend file: press i and then click with right mouse button
* Save and close this file: press ESC, now write wq, press ENTER

***OR***

Simply copy this script from GitHub
```
mkdir -p ~/backups/ && wget -O ~/backups/backup.sh https://raw.githubusercontent.com/kamdhenu/EasyS3/master/backup.sh
```

3. Edit the downloaded `backup.sh` file and enter your S3 Bucket name


4. Make this script executable:
```
chmod +x ~/backups/backup.sh
```

5. If you want to exclude certain files/directories, create a file called "exclude.txt" inside the backups directory
6. Add pattern/path for all excluded files/directories in this file (one per line) and save it
7. Run this script to start backup immidiately

***FINALLY***

8. Set cron job to automate the backup:
```
/root/backups/backup.sh >/dev/null 2>&1
```

***IMPORTANT***

You may also want to setup an [Object Expiration Policy](https://aws.amazon.com/blogs/aws/amazon-s3-object-expiration/) for your s3 bucke to auto delete/archive old backup files from your bucket.
