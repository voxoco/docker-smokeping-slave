FROM lsiobase/alpine:3.11
MAINTAINER LinuxServer.io <ironicbadger@linuxserver.io>, sparklyballs

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SMOKEPING_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# copy tcpping script
COPY tcpping /defaults/

# install packages
RUN \
 apk add --no-cache \
    perl \
    perl-lwp-protocol-https \
    curl \
    smokeping \
    ssmtp \
    sudo \
    tcptraceroute \
    ttf-dejavu && \
echo "**** give setuid access to traceroute & tcptraceroute ****" && \
chmod a+s /usr/bin/traceroute && \
chmod a+s /usr/bin/tcptraceroute && \
echo "**** fix path to cropper.js ****" && \
sed -i 's#src="/cropper/#/src="cropper/#' /etc/smokeping/basepage.html && \
echo "**** install tcping script ****" && \
install -m755 -D /defaults/tcpping /usr/bin/ && \

# give abc sudo access to traceroute
echo "abc ALL=(ALL) NOPASSWD: /usr/bin/traceroute" >> /etc/sudoers.d/traceroute &&
 
RUN ln -snf /usr/share/zoneinfo/America/Chicago /etc/localtime && echo America/Chicago > /etc/timezone

RUN ln -s /usr/sbin/fping /usr/bin/fping

# add local files
COPY root/ /

# ports and volumes
VOLUME /config /data
