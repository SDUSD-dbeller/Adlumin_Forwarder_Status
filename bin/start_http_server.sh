#!/bin/bash
##################################################
# Filename: /home/adlumin/bin/start_http_server.sh
# Created: 6/18/2024
# Created By: Dave Beller
# Purpose: Run http server for service monitoring. File /home/adlumin/log/AdluminForwarderStatus.html is monitored for service uptime. That file is created by /home/adlumin/bin/adluminForwarderStatusCheck.sh which is run by an Adlumin user cron job every minute  
#
# Script should be run as a service. Setup instructions:
# systemd service file: /etc/systemd/system/http_server.service
#
# Reload systemd:
#   sudo systemctl daemon-reload
#
# Enable service to start on boot:
#   sudo systemctl enable http_server.service
#
# Start service immediately:
#   sudo systemctl start http_server.service
#
# Check status
#
#   sudo systemctl status http_server.service
#
#Changelog:
#  20240618 Script created
#
#
##################################################

#Set exit on error, exit on unset variable, disable filename expansion, return pipeline error if any command fails
set -euf -o pipefail

# Source the configuration file
source /home/adlumin/etc/check_adlumin_status.conf

# Change to the directory containing the log file
cd /home/adlumin/log

# Start the Python HTTP server on port specified in conf file
nohup python3 -m http.server $HTTP_PORT &
