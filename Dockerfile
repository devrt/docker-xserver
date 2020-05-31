FROM node:12 AS novnc

# noVNC with chrome77 workaround patch
RUN git clone https://github.com/phcapde/noVNC.git /novnc

RUN cd /novnc && \
    npm install && \
    ./utils/use_require.js --as commonjs --with-app --clean

FROM ubuntu:18.04

MAINTAINER Yosuke Matsusaka <yosuke.matsusaka@gmail.com>

ENV DISPLAY ":0"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl ca-certificates fluxbox xfonts-base xauth x11-xkb-utils xkb-data dbus-x11 python3 python3-pip supervisor && \
    curl -L https://bintray.com/tigervnc/stable/download_file?file_path=tigervnc-1.10.1.x86_64.tar.gz | tar xz --strip 1 -C / && \
    pip3 install -U setuptools wheel && \
    pip3 install -U websockify && \
    apt-get remove -y python3-pip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=novnc /novnc/build /novnc

COPY . /app

RUN cp /app/index.html /novnc/

VOLUME /tmp/.X11-unix

EXPOSE 80

CMD ["supervisord", "-c", "/app/supervisord.conf"]