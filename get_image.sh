#!/bin/bash

# Domain of the URL.
DOMAIN='https://www.bing.com'
#Base of image from Bing.
PIC_BASE="$(curl 'https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-US' | jq '.images|.[0]|.url')"
PIC_BASE=${PIC_BASE//\"/} # Remove all '"' resulting from JSON.
# Formulate image URL.

PIC_URL=$(echo "$DOMAIN""$PIC_BASE")

# TODO: Intallation sequence.
<<-"delim"
Installation sequence should perform:
- Set up CRON job to update picture daily.
delim

# Cron job installation.
function install () {
	# Install cronjob.
	cat - > update_image_crontab <<delim
# Following will record current directory in environment variable.
IOTD=$PWD
# Run script every first hour of everyday.
0 1 * * *	$PWD/get_image.sh -u
delim
# User must be on `cron.allow` list; or must not be on `cron.deny`; otherwise should run as super-user.
crontab -u $USER $PWD/update_image_crontab
}

function update_image () {
	wget "$PIC_URL" -O ${IOTD:-"$PWD"}/image_of_the_day.jpg
}

function help_menu () {
	:
}

# Option parsing.
if [[ $1 == '-i' ]]; then
	install
elif [[ $1 == '-u' ]]; then
	update_image
else
	echo -e "Unknown command $1\n"
	# COMEBAK: Write help menu.
	help_menu
fi
