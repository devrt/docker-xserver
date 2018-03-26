FROM ubuntu:artful

MAINTAINER Yosuke Matsusaka <yosuke.matsusaka@gmail.com>

ENV DISPLAY ":0"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl apt-transport-https software-properties-common && \
    curl https://winswitch.org/gpg.asc | apt-key add - && \
    sh -c 'echo "deb http://winswitch.org/ artful main" > /etc/apt/sources.list.d/winswitch.list' && \
    add-apt-repository universe && \
    apt-get update && \
    apt-get install --no-install-recommends -y xpra websockify libjs-jquery fluxbox xfonts-base novnc supervisor x11vnc && \
    apt-get remove -y curl software-properties-common && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY . /app

VOLUME /tmp/.X11-unix

EXPOSE 80 8080

CMD ["supervisord", "-c", "/app/supervisord.conf"]