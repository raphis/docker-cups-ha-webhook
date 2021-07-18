#!/bin/bash

# source config file
. /config/config.sh

# trigger HA webhook
curl -X POST $WEBHOOK_URL

# wait X-seconds for printer bootup
sleep $PRINTER_BOOTTIME
