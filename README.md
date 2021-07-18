# Purpose
The main goal of this project/repository is to turn on a smart power-switch via Home Assistant when a print job is present. To achieve this a dedicated docker container with CUPS and tea4cups is started.

## Howto / Setup
1. Download and adjust configuration files from repository (folder config) - Note: the printer name in printers.conf must match the name mentioned in tea4cups.conf

2. Setup the webhook/automation in Home Assistant (folder ha-config)
2. Copy configuration files to your config file directory (e.g. /usr/share/cups-ha-webhook)
3. Pull the docker container from the repository
```
docker pull raphithom/cups-ha-webhook:latest
```
4. Run the container with the corresponding options
```
docker run -d --name "cups-ha-webhook" -p 631:631 -v /usr/share/cups-ha-webhook:/config raphithom/cups-ha-webhook:latest
```
