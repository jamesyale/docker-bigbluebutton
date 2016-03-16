FROM ubuntu:14.04
MAINTAINER James Yale jim@thebiggame.org

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y language-pack-en vim wget curl
RUN update-locale LANG=en_US.UTF-8
RUN dpkg-reconfigure locales

# Enable multiverse

RUN /bin/sed -i 's@# deb http://archive.ubuntu.com/ubuntu/ trusty-security multiverse@deb http://archive.ubuntu.com/ubuntu/ trusty-security multiverse@' /etc/apt/sources.list

# Add OpenOffice

RUN apt-get install -y --no-install-recommends software-properties-common
RUN add-apt-repository ppa:libreoffice/libreoffice-4-4

# Add the BigBlueButton key
RUN wget http://ubuntu.bigbluebutton.org/bigbluebutton.asc -O- | apt-key add -

# Add the BigBlueButton repository URL and ensure the multiverse is enabled
RUN echo "deb http://ubuntu.bigbluebutton.org/trusty-090/ bigbluebutton-trusty main" | tee /etc/apt/sources.list.d/bigbluebutton.list

# ffmpeg PPA

RUN echo "deb http://ppa.launchpad.net/mc3man/trusty-media/ubuntu trusty main" | tee /etc/apt/sources.list.d/trusty-media.list
RUN echo "deb-src http://ppa.launchpad.net/mc3man/trusty-media/ubuntu trusty main" | tee /etc/apt/sources.list.d/trusty-media-src.list

# Update!

RUN apt-get -y clean &&apt-get -y update && apt-get -y dist-upgrade

RUN apt-get -y --force-yes --no-install-recommends install bbb-web ; exit 0
RUN apt-get -y --force-yes --no-install-recommends install bigbluebutton ; exit 0


EXPOSE 80 9123 1935

#Add helper script to start bbb
COPY scripts/bbb-start.sh /usr/bin/

CMD ["/usr/bin/bbb-start.sh"]
