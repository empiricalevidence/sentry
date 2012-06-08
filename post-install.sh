#!/bin/bash
# You should run this script as your regular user
set -e
pip install -r requirements.txt
echo "Enter the MySQL password of root"
mysql -u root -p -e "CREATE DATABASE sentry"
sentry --config=/opt/sentry/etc/sentry.conf.py upgrade
