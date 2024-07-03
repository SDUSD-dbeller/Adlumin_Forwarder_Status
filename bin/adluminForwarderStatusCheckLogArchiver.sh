#!/bin/bash

##################################################
# Filename: /home/adlumin/bin/adluminForwarderStatusCheckLogArchiver.sh 
# Created: 7/3/2024
# Created By: Dave Beller
# Purpose: Archive AdluminForwarderStatus.log periodically
#
# Script should be run by adlumin cron. Set the frequency to the minimum desired log archive.
#
#Changelog:
#  20240703 DB Script created
#
##################################################

#Set exit on error, exit on unset variable, disable filename expansion, return pipeline error if any command fails
set -euf -o pipefail

#Source the configuration file
source /home/adlumin/check_adlumin_status.conf

# Rename the log file to the archive file, overwriting the archive if it exists
mv -f "$LOG_FILE" "$ARCHIVE_FILE"

# Set permissions for the archive file
chmod 644 "$ARCHIVE_FILE"

# Inform the user
echo "Log file has been renamed to archive file."
