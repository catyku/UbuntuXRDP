# https://github.com/danchitnis/container-xrdp

FROM ubuntu:22.04

MAINTAINER catyku https://blog.yslifes.com

ENV DEBIAN_FRONTEND noninteractive


RUN apt-get -y update 
RUN apt-get -y upgrade

RUN apt-get install -y \
    xfce4 \
    xfce4-clipman-plugin \
    xfce4-cpugraph-plugin \
    xfce4-netload-plugin \
    xfce4-screenshooter \
    xfce4-taskmanager \
    xfce4-terminal \
    xfce4-xkb-plugin 

RUN apt install software-properties-common -y

## install firefox as web browser
RUN add-apt-repository ppa:mozillateam/ppa

RUN echo '\
Package: *\n\
Pin: release o=LP-PPA-mozillateam\n\
Pin-Priority: 1001\n\
' |  tee /etc/apt/preferences.d/mozilla-firefox

RUN echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' |  tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox


# install chinese fonts
RUN apt-get install -y language-pack-zh*  
#chinese*
RUN apt-get install -y fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core


# install some tool and ibus ime
RUN apt-get install -y \
    sudo \
    wget \
    xorgxrdp \
    xrdp \
    git \
    dbus-x11 \
    ibus ibus-pinyin ibus-table-cangjie \
    nano tar 


RUN  apt remove -y light-locker xscreensaver && \
    apt autoremove -y && \
    rm -rf /var/cache/apt /var/lib/apt/lists


COPY ./build/ubuntu-run.sh /usr/bin/
RUN mv /usr/bin/ubuntu-run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

COPY ./build/bashrc /bashrc
COPY ./build/xsessionrc /xsessionrc

# https://github.com/danielguerra69/ubuntu-xrdp/blob/master/Dockerfile
RUN mkdir /var/run/dbus && \
    cp /etc/X11/xrdp/xorg.conf /etc/X11 && \
    sed -i "s/console/anybody/g" /etc/X11/Xwrapper.config && \
    sed -i "s/xrdp\/xorg/xorg/g" /etc/xrdp/sesman.ini && \
    echo "xfce4-session" >> /etc/skel/.Xsession

# real install firefox 
RUN apt upgrade -y && apt update -y  && apt install firefox -y 

# Docker config
EXPOSE 3389
ENTRYPOINT ["/usr/bin/run.sh"]
