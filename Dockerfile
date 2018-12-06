FROM debian:stretch-slim

#Install the actual resiprocate-tun-server deb package
RUN apt-get update \
	&& apt-get install -y resiprocate-turn-server

#reTurn includes two services. STUN (which listens on port 3478/udp) and TURN (3478/tcp)
EXPOSE 3478/tcp
EXPOSE 3478/udp

#Copying a modified and thinned reTurn config
COPY reTurnServer.config /etc/reTurn/

#Copying the init script that handles crucial config params (IP address and credentials)
COPY reTurn_init.sh /usr/local/bin/

#Setting ENTRYPOINT and CMD
ENTRYPOINT [ "/bin/bash", "/usr/local/bin/reTurn_init.sh" ]
CMD ["/usr/sbin/reTurnServer", "/etc/reTurn/reTurnServer.config", "--PidFile=/var/run/reTurnServer/reTurnServer.pid"]
