#!/bin/sh
RESET="\e[0m"
WHITE="\e[37m"
GREEN="\e[32m"
RED="\e[31m"

alias echo='echo -e'
echo "$WHITE[Backup Script v0.1]$RESET"

date=`date "+%d-%m-%YT%H:%M:%S`
remote_host=sydney.matthewbrown.io
remote_user=rsync
base_backup_dir=/volume1/homes/backup/sydney.matthewbrown.io/
db_backup_dir=database

echo ""
echo "[$GREEN+$RESET] Initializing program"
echo "------------------------------------"

rsync -aPhz --numeric-ids --log-file=/volume1/homes/backup/sydney.matthewbrown.io/backup-$date.log --link-dest=/volume1/homes/backup/sydney.matthewbrown.io/current rsync@sydney.mat
rm -f /volume1/homes/backup/sydney.matthewbrown.io/current
ln -s /volume1/homes/backup/sydney.matthewbrown.io/backup-$date /volume1/homes/backup/sydney.matthewbrown.io/current

if [ -d "$base_backup_dir/$db_backup_dir" ]; then
       mkdir -p database
fi
ssh rsync@sydney.matthewbrown.io "pg_dumpall --globals-only | bzip2 -vf" > dadb-globals-$date.bz2
