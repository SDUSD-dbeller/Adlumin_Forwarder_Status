#!/bin/bash
##################################################
# Filename: /home/adlumin/bin/adluminForwarderStatusCheck.sh
# Created: 6/18/2024
# Created By: Dave Beller
# Purpose: Check status of Adlumin forwarder and write it to /home/adlumin/log/AdluminForwarderStatus.html, which is monitored by the Kemp load balancer.
#
# Script should be run by adlumin cron. Suggested frequency is 1 minute.
#
#Changelog:
#  20240618 DB Script created
#  20240702 DB Added conf file, status change email, logging
#
##################################################
#

#Set exit on error, exit on unset variable, disable filename expansion, return pipeline error if any command fails
set -euf -o pipefail

# Source the configuration file
source /home/adlumin/etc/check_adlumin_status.conf

#Get server IP
server_ip=$(hostname -I | awk '{print $1}')

# Run the adlumin_status command and capture its output
output=$(adlumin_status)

# Get current date and time
current_datetime=$(date '+%Y-%m-%d %H:%M:%S')

# Check if the output contains "Active: active (running)"
if echo "$output" | grep -q "Active: active (running)"; then
    # If the string is found, write the status message to the file and log and set current status to up for status change email
    current_status="up"
    echo "Adlumin Forwarder up" > $HTML_FILE
    echo "$current_datetime - Adlumin Forwarder $current_status" >> $LOG_FILE
else
    # if the string is not found, write the down status message to the file and log
    current_status="down"
    echo "Adlumin Forwarder down" > $HTML_FILE
    echo "$current_datetime - Adlumin Forwarder $current_status" >> $LOG_FILE

fi
# Set the permissions for the htmp file and the log file to 644
chmod 644 $HTML_FILE
chmod 644 $LOG_FILE

# Read the last known status
if [[ -f $STATUS_FILE ]]; then
    last_status=$(cat $STATUS_FILE)
else
    last_status="unknown"
fi

# Check if the status has changed
if [[ "$current_status" != "$last_status" ]]; then
    # Send an email notification
    echo "The $server_ip Adlumin Forwarder status has changed to $current_status." | mail -r $EMAIL_SENDER -s "$server_ip $EMAIL_SUBJECT : $current_status" $EMAIL_RECIPIENT
fi

# Update the last known status
echo $current_status > $STATUS_FILE
