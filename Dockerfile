FROM ubuntu:latest

ENV build_path /tmp/build_shadowsocks/
ENV source_path /tmp/build_shadowsocks/shadowsocks-libev/
ENV depend_apt git wget build-essential autoconf libtool libssl-dev \
    gawk debhelper dh-systemd init-system-helpers pkg-config asciidoc \
    xmlto apg libpcre3-dev vim ca-certificates

RUN apt-get -y update && apt-get upgrade -y
RUN apt-get -y install --no-install-recommends ${depend_apt}
RUN git config --global http.sslVerify true
RUN mkdir -p ${build_path} && \
    cd ${build_path} && \
    git clone https://github.com/shadowsocks/shadowsocks-libev.git
RUN cd ${source_path} && \
    dpkg-buildpackage -b -us -uc -i
RUN cd ${build_path} && \
    dpkg -i shadowsocks-libev*.deb
RUN cat /etc/shadowsocks-libev/config.json
RUN rm -rfv ${build_path}

EXPOSE 8388

#CMD /etc/init.d/shadowsocks-libev start
#CMD service shadowsocks-libev start
#CMD /usr/bin/ss-server -s 127.0.0.1 -p 8388 -l 1080 -k 123456 -m aes-256-cfb -a nobody -t 60 -u --fast-open 
