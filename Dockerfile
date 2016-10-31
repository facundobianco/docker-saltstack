FROM alpine:3.4
MAINTAINER curratore <frodriguezd@gmail.com>

COPY master /etc/salt/master
COPY minion /etc/salt/minion
COPY saltstack.run /usr/local/bin/saltstack.run

RUN apk update && \
    apk add --no-cache -X http://dl-4.alpinelinux.org/alpine/edge/main python2 \
    py2-crypto \
    py2-jinja2 \ 
    py2-tornado \
    py2-yaml \
    py2-cffi \
    py2-six \
    py2-requests \
    py2-dateutil

RUN apk add --no-cache -X http://dl-4.alpinelinux.org/alpine/edge/community py2-msgpack \ 
    py2-zmq \ 
    salt \
    salt-master \
    salt-minion 

RUN mkdir -p /srv/salt /srv/pillar
RUN chmod 0700 /srv/pillar \
    && chmod +x /usr/local/bin/saltstack.run

RUN salt-master -d && salt-minion -d && while(true) ; do salt-key -yA && break || sleep 15 ; done



EXPOSE 4505 4506 
VOLUME ["/srv/salt", "/srv/pillar"] 
CMD ["/usr/local/bin/saltstack.run"]