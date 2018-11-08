#!/bin/sh

# Start the cron job
crond -L /var/log/cron.log

# Start Nginx process
nginx -g "daemon off;"
