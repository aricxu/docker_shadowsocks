FROM ubuntu:latest

RUN apt-get -y update && apt-get upgrade -y
RUN apt-get -y install --no-install-recommends git wget build-essential autoconf libtool libssl-dev \
    gawk debhelper dh-systemd init-system-helpers pkg-config asciidoc xmlto apg libpcre3-dev vim \
    ca-certificates
RUN git config --global http.sslVerify true
RUN mkdir -p /tmp/build_shadowsocks && \
    cd /tmp/build_shadowsocks && \
    git clone https://github.com/shadowsocks/shadowsocks-libev.git
RUN cd /tmp/build_shadowsocks/shadowsocks-libev && \
    dpkg-buildpackage -b -us -uc -i
RUN cd /tmp/build_shadowsocks && \
    dpkg -i shadowsocks-libev*.deb
RUN cat /etc/shadowsocks-libev/config.json

CMD /etc/init.d/shadowsocks-libev start
