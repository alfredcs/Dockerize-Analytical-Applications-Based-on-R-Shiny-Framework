#!/bin/sh

# Make sure the directory for individual app logs exists
mkdir -p /var/log/shiny-server
chown shiny.shiny /var/log/shiny-server

exec shiny-server  >> /var/log/shiny-server/server.log 2>&1
#exec Rscript /opt/apps/runApp.R  >> /var/log/shiny-server/app.log 2>&1
