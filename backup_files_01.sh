#!/bin/bash

#__author__ = "Paolo Ventriglia"
#__credits__ = ["Paolo Ventriglia"]
#__license__ = "GPL"
#__version__ = ""
#__maintainer__ = "Paolo Ventriglia"
#__email__ = "paolo@corebox.co.uk"

BACKUPTIME=`date +%b-%d-%y` #get the current date

DESTINATION=/home/usr/path/backup-$BACKUPTIME.tar.gz #create a backup file using the current date in it's name

SOURCEFOLDER=/home/usr/path/data_folder #the folder that contains the files that we want to backup

tar -cpzf $DESTINATION $SOURCEFOLDER #create the backup