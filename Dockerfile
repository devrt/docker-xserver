FROM node:12 AS novnc

RUN mkdir -p /novnc && \
    curl -L https://github.com/novnc/noVNC/archive/v1.1.0.tar.gz | tar xz --strip 1 -C /novnc

RUN cd /novnc && \
    npm install && \
    ./utils/use_require.js --as commonjs --with-app --clean

FROM ubuntu:18.04

MAINTAINER Yosuke Matsusaka <yosuke.matsusaka@gmail.com>

ENV DISPLAY ":0"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl ca-certificates websockify fluxbox xfonts-base xauth x11-xkb-utils xkb-data dbus-x11 supervisor && \
    curl -L https://bintray.com/tigervnc/stable/download_file?file_path=tigervnc-1.9.0.x86_64.tar.gz | tar xz --strip 1 -C / && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=novnc /novnc/build /novnc

COPY . /app

RUN cp /app/index.html /novnc/

VOLUME /tmp/.X11-unix

EXPOSE 80

CMD ["supervisord", "-c", "/app/supervisord.conf"]