FROM debian:8.2
MAINTAINER Facundo Bianco < vando [at] van [dot] do >

#ENV MVER 2015.5.3+ds-1~bpo8+1
ENV TERM xterm
ENV PATH $PATH:/usr/local/sbin:/usr/local/bin

ADD https://raw.githubusercontent.com/saltstack/salt-vim/master/ftdetect/sls.vim /root/.vim/ftdetect/
ADD https://raw.githubusercontent.com/saltstack/salt-vim/master/ftplugin/sls.vim /root/.vim/ftplugin/
ADD https://raw.githubusercontent.com/saltstack/salt-vim/master/syntax/sls.vim /root/.vim/syntax/

COPY conf/vimrc /root/.vimrc
COPY conf/mg /root/.mg

COPY bin/* /usr/local/bin/
RUN find /usr/local/bin -type f -not -executable -exec chmod +x {} \;

RUN echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4

RUN if [ -z "$MVER" ] ; \
    then \
        echo "deb http://httpredir.debian.org/debian/ sid main" > \
        /etc/apt/sources.list.d/sid.list ; \
    else \
        wget -qO - 'http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0xF2AE6AB9' | \
	     sed -n '/BEGIN/,/END/p' | apt-key add - ; \
        echo "deb http://debian.saltstack.com/debian jessie-saltstack main" > \
	/etc/apt/sources.list.d/saltstack.list ; \
    fi

RUN apt-get update && apt-get install -y --no-install-recommends \
    salt-master=${MVER:-2015.8.1+ds-2} salt-minion=${MVER:-2015.8.1+ds-2} mg vim

RUN sed -i 's/^#master: salt/master: 127.0.0.1/;s/^#id:/id: minion/' /etc/salt/minion
RUN mkdir /srv/salt /srv/pillar
RUN chmod 0700 /srv/pillar

CMD ["/usr/local/bin/saltstack.run"]
