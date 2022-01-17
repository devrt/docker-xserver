FROM ubuntu:20.04

MAINTAINER Yosuke Matsusaka <yosuke.matsusaka@gmail.com>

ENV DISPLAY ":0"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y wget ca-certificates fluxbox xfonts-base xauth x11-xkb-utils xkb-data dbus-x11 eterm python3 python3-pip supervisor && \
    wget https://sourceforge.net/projects/tigervnc/files/stable/1.12.0/ubuntu-20.04LTS/$(dpkg --print-architecture)/tigervncserver_1.12.0-1ubuntu1_$(dpkg --print-architecture).deb && \
    apt-get install -y ./tigervncserver_*.deb && \
    pip3 install -U setuptools wheel && \
    pip3 install -U websockify && \
    apt-get remove -y python3-pip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm tigervncserver_*.deb && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /novnc && \
    wget -qO- "http://github.com/novnc/noVNC/tarball/master" | tar -zx --strip-components=1 -C /novnc

COPY . /app

RUN cp /app/index.html /novnc/

VOLUME /tmp/.X11-unix

EXPOSE 80

CMD ["supervisord", "-c", "/app/supervisord.conf"]