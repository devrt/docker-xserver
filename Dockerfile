FROM ubuntu:artful

MAINTAINER Yosuke Matsusaka <yosuke.matsusaka@gmail.com>

ENV DISPLAY ":0"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y git curl apt-transport-https software-properties-common && \
    sh -c 'echo "deb http://winswitch.org/ artful main" > /etc/apt/sources.list.d/winswitch.list' && \
    curl http://winswitch.org/gpg.asc | apt-key add - && \
	add-apt-repository universe && \
	apt-get update && \
    apt-get install --no-install-recommends -y xpra websockify libjs-jquery fluxbox eterm mesa-utils x11-utils xfonts-base && \
	apt-get clean

RUN curl -L https://github.com/krallin/tini/releases/download/v0.16.1/tini-amd64 -o /sbin/tini && \
    chmod a+x /sbin/tini

ADD entrypoint.sh /bin/entrypoint.sh

VOLUME /tmp/.X11-unix

EXPOSE 8080

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/bin/entrypoint.sh"]