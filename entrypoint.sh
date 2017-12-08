#!/bin/sh

xpra --xvfb="Xorg -noreset -ac -pn -dpms \
     -config /etc/xpra/xorg.conf \
     +extension GLX +extension RANDR +extension RENDER" start-desktop :0 \
     --start="fluxbox" --bind-tcp=0.0.0.0:8080 --html=on --daemon=no
