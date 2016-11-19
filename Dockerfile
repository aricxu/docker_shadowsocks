FROM ubuntu:latest

RUN apt-get -y update && apt-get upgrade -y
RUN apt-get -y install --no-install-recommends git wget build-essential autoconf libtool libssl-dev \
    gawk debhelper dh-systemd init-system-helpers pkg-config asciidoc xmlto apg libpcre3-dev vim
RUN cd 
RUN git config --global core.longpaths true
RUN git clone https://github.com/shadowsocks/shadowsocks-libev.git
RUN cd shadowsocks-libev
RUN dpkg-buildpackage -b -us -uc -i
RUN cd ..
RUN dpkg -i shadowsocks-libev*.deb
RUN cat /etc/shadowsocks-libev/config.json

CMD /etc/init.d/shadowsocks-libev start
