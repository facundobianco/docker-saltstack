FROM debian:8.2
MAINTAINER Facundo Bianco < vando [at] van [dot] do >

ENV MVER 2015.8.1+ds-2
ENV OSCN sid
ENV TERM xterm

COPY saltstack.run /root/

RUN echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4
RUN echo "deb http://httpredir.debian.org/debian/ $OSCN main" > \
         /etc/apt/sources.list.d/sid.list

RUN apt-get update && \
    apt-get install -y --no-install-recommends salt-master=${MVER} salt-minion=${MVER} mg

RUN sed -i 's/^#master: salt/master: 127.0.0.1/;s/^#id:/id: minion/' /etc/salt/minion
RUN mkdir /srv/{salt,pillar}
RUN chmod 0700 /srv/pillar

RUN chmod +x /root/saltstack.run
CMD ["/root/saltstack.run"]
