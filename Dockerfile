FROM debian:stable-slim as base

RUN apt-get update \
&& apt-get install -y \
  sudo \
  curl \
  jq \
  cups \
  cups-client \
  cups-bsd \
  cups-tea4cups \
  cups-filters \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

FROM base as mods

COPY src/trigger-printer-webhook.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/trigger-printer-webhook.sh

# Configure the service's to be reachable
RUN /usr/sbin/cupsd \
  && while [ ! -f /var/run/cups/cupsd.pid ]; do sleep 1; done \
  && cupsctl --remote-admin --remote-any --share-printers \
  && kill $(cat /var/run/cups/cupsd.pid)

RUN ln -s /config/printers.conf /etc/cups/printers.conf
RUN rm -f /etc/cups/tea4cups.conf
RUN ln -s /config/tea4cups.conf /etc/cups/tea4cups.conf

EXPOSE 631/tcp

# Default shell
CMD ["/usr/sbin/cupsd", "-f"]
