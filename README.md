Adlumin Forwarder Status Check

This project monitors and logs the status of the Adlumin Forwarder service. It sends alerts when the status changes. It serves a status page via http. The status page can be monitored by a load balancer to shift log forwarding to a secondary log forwarder. It also monitors the forwarder appliance and sends a daily email when a reboot is required.

Dependencies:

Sending mail alerts requires mailutils be installed and configured:
	Install:
		sudo apt-get install mailutils
	Configure:
		Choose Internet Site to use a SMTP relay
		Edit /etc/postfix/main.cf
			Either add the destination domains to mydestination = or comment out the mydestination line to allow sending to all domains
			enter SMTP relay in relayhost, e.g. relayhost = mail.mydomain.com

http_server.service
	Service file to run python3 http server. Should be placed in /etc/systemd/system/

start_http_server.sh
	Starts http server on port defined in check_adlumin_status.conf. The service runs as user adlumin, so it should use a port above 1023.

adluminForwarderStatusCheck.sh
	Script checks whether the adlumin_forwarder service is running and writes the results to a html file. Also writes the status to a log file. If the status has changed since the last check, sends an email to recipients defined in check_adlumin_status.conf. The schedule set in cron will determine how often this is checked.

adluminForwarderStatusCheckLogArchiver.sh
	Script renames the log file so a new log file is created on the next check. The schedule set in cron will determine how long logs are archived.

adluminForwarderCheckRebootRequired.sh
	Script checks if the appliance needs a reboot and sends an email to recipients defined in check_adlumin_status.conf if it is. The schedule set in cron will determine how often this is checked.

check_adlumin_status.conf
	Contains variables that may be set. The location of this file in the scripts is /home/adlumin/etc/check_adlumin_status.conf. If it is stored elsewhere, each script needs to be edited to reflect the correct location. Variables included:

\# Email addresses to send notifications to, seperated with spaces
EMAIL_RECIPIENT="recipient1@domain.com recipient2@domain.com"

\# Email sender address to send notifications from
EMAIL_SENDER="recipient1@domain.com recipient2@domain.com"

\# Subject for the email notifications
EMAIL_SUBJECT="Adlumin Forwarder Status Change"

\# Path to the status file
STATUS_FILE="/home/adlumin/log/AdluminForwarderStatus.last"

\# Path to the log file
LOG_FILE="/home/adlumin/log/AdluminForwarderStatus.log"

\# Path to the HTML file
HTML_FILE="/home/adlumin/log/AdluminForwarderStatus.html"

\# Path to the log archive file
ARCHIVE_FILE="/home/adlumin/log/AdluminForwarderStatus_archive.log"

\# HTTP Server port
HTTP_PORT="8080"





User adlumin crontab entries (running status check every minute, archiving a week's worth of logs every Sunday at 00:00, and checking if a reboot is required every day at 7:00 and 13:00. Change the timing and script locations as desired):

\* \* \* \* \* /home/adlumin/bin/adluminForwarderStatusCheck.sh

0 0 \* \* 0 /home/adlumin/bin/adluminForwarderStatusCheckLogArchiver.sh

0 7,13 \* \* \* /home/adlumin/bin/adluminForwarderCheckRebootRequired.sh
