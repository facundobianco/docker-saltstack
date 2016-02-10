FROM debian:8.2
MAINTAINER Facundo Bianco <vando@van.do>

ENV MVER 2015.8.5+ds-1

ENV TERM xterm
ENV PATH $PATH:/usr/local/sbin:/usr/local/bin

ADD https://raw.githubusercontent.com/saltstack/salt-vim/master/ftdetect/sls.vim /root/.vim/ftdetect/
ADD https://raw.githubusercontent.com/saltstack/salt-vim/master/ftplugin/sls.vim /root/.vim/ftplugin/
ADD https://raw.githubusercontent.com/saltstack/salt-vim/master/syntax/sls.vim /root/.vim/syntax/

ADD conf/vimrc /root/.vimrc
ADD conf/mg /root/.mg

ADD bin/* /usr/local/bin/
RUN find /usr/local/bin -type f -not -executable -exec chmod +x {} \;

RUN echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4

RUN echo "deb http://httpredir.debian.org/debian/ sid main" > /etc/apt/sources.list.d/sid.list 
RUN echo "deb http://debian.saltstack.com/debian jessie-saltstack main" > /etc/apt/sources.list.d/saltstack.list
RUN wget -qO - 'http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0xF2AE6AB9' | sed -n '/BEGIN/,/END/p' | apt-key add -

RUN apt-get update && apt-get install -y --no-install-recommends \
    salt-master=${MVER} salt-minion=${MVER} mg vim-tiny

RUN sed -i 's/^#master: salt/master: 127.0.0.1/;s/^#id:/id: minion/' /etc/salt/minion
RUN sed -i 's/^#worker_threads: 5/worker_threads: 20/' /etc/salt/master
RUN salt-master -d && salt-minion -d && while(true) ; do salt-key -yA && break || sleep 15 ; done

RUN mkdir /srv/salt /srv/pillar
RUN chmod 0700 /srv/pillar

EXPOSE 4505 4506
VOLUME ["/srv/salt", "/srv/pillar"]
CMD ["/usr/local/bin/saltstack.run"]
