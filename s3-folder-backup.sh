#!/bin/sh

#### BEGIN CONFIGURATION ####

# set dates for backup rotation
NOWDATE=`date +%Y-%m-%d`
LASTDATE=$(date +%Y-%m-%d --date='1 week ago')

# set dump directory variables
SRCDIR='/tmp/s3backups'
DESTDIR='path/to/folder'
BUCKET='bucket-name'

DIRECTORY='';

#### END CONFIGURATION ####

# make the temp directory if it doesn't exist
mkdir -p $SRCDIR

# tar all the databases into $NOWDATE-backups.tar.gz
cd $SRCDIR
tar -czPf $NOWDATE-backup.tar.gz $DIRECTORY

# upload backup to s3
s3cmd put $SRCDIR/$NOWDATE-backup.tar.gz s3://$BUCKET/$DESTDIR/

# delete old backups from s3
s3cmd del --recursive s3://$BUCKET/$DESTDIR/$LASTDATE-backup.tar.gz

# remove all files in our source directory
cd
rm -f $SRCDIR/*
