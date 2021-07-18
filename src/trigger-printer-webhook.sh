#!/bin/bash

# trigger HA webhook
curl -X POST http://192.168.1.253:8123/api/webhook/hp-ljp-m276nw

# wait for 50s to bootup
sleep 50
