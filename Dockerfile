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

RUN echo "[HP_LaserJet_M276nw]" >> /etc/cups/tea4cups.conf
RUN echo "prehook_poweron_printer : /usr/local/bin/trigger-printer-webhook.sh" >> /etc/cups/tea4cups.conf

# Configure the service's to be reachable
RUN /usr/sbin/cupsd \
  && while [ ! -f /var/run/cups/cupsd.pid ]; do sleep 1; done \
  && cupsctl --remote-admin --remote-any --share-printers \
  && kill $(cat /var/run/cups/cupsd.pid)

COPY src/printers.conf /etc/cups/printers.conf

EXPOSE 631/tcp

# Default shell
CMD ["/usr/sbin/cupsd", "-f"]
