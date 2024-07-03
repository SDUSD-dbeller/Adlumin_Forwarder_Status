#!/bin/bash

##################################################
# Filename: /home/adlumin/bin/adluminForwarderCheckRebootRequired.sh 
# Created: 7/3/2024
# Created By: Dave Beller
# Purpose: Check whether the forwarder appliance needs a reboot. If it does, send an email to recipients defined in check_adlumin_status.conf.
#
# Script should be run by adlumin cron. Set the frequency as desired. Recommend at least daily.
#
#Changelog:
#  20240703 DB Script created
#
##################################################


#Set exit on error, exit on unset variable, disable filename expansion, return pipeline error if any command fails
set -euf -o pipefail

# Source the configuration file
source /home/adlumin/etc/check_adlumin_status.conf

# Check for the existence of /var/run/reboot-required
if [[ -f /var/run/reboot-required ]]; then
    # Get the server's IP address
    server_ip=$(hostname -I | awk '{print $1}')

    # Modify the email subject to include the server's IP address
    email_subject_with_ip="Adlumin Forwarder Needs Restart - $server_ip"

    # Email body
    email_body="The adlumin forwarder requires a restart - $server_ip"

    # Send the email notification
    echo "$email_body" | mail -s "$email_subject_with_ip" -r $EMAIL_SENDER $EMAIL_RECIPIENT
fi
