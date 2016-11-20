FROM ubuntu:latest

ENV build_path /tmp/build_shadowsocks/
ENV source_path /tmp/build_shadowsocks/shadowsocks-libev/
ENV depend_apt git build-essential autoconf libtool libssl-dev \
    gawk debhelper dh-systemd init-system-helpers pkg-config asciidoc \
    xmlto apg libpcre3-dev ca-certificates

RUN apt-get -y update && apt-get upgrade -y
RUN apt-get -y install --no-install-recommends ${depend_apt}
RUN git config --global http.sslVerify true
RUN mkdir -p ${build_path}

WORKDIR ${build_path}

RUN git clone https://github.com/shadowsocks/shadowsocks-libev.git

WORKDIR ${source_path}

RUN dpkg-buildpackage -b -us -uc -i

WORKDIR ${build_path}
RUN dpkg -i shadowsocks-libev*.deb
RUN rm -rfv ${build_path}

EXPOSE 8388

#CMD /etc/init.d/shadowsocks-libev start
#CMD service shadowsocks-libev start
#CMD /usr/bin/ss-server -s 127.0.0.1 -p 8388 -l 1080 -k 123456 -m aes-256-cfb -a nobody -t 60 -u --fast-open -f /var/run/shadowsocks.pid
