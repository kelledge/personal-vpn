#!/bin/bash
set -e

OVPN_VOLUME="ovpn-data"

docker volume rm -f "${OVPN_VOLUME}"
docker volume create "${OVPN_VOLUME}"

# This is probably more trouble that it is worth compared to a Dockerfile
# FIXME: Script should be added to image.
docker run -v "${OVPN_VOLUME}":/data --name tmp busybox true
docker cp ./learn-address.sh tmp:/data
docker rm tmp

docker run -v $OVPN_VOLUME:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig \
  -c \
  -n 172.16.238.254 \
  -p "dhcp-option DOMAIN-SEARCH testing.local" \
  -e 'script-security 2' \
  -e 'learn-address /etc/openvpn/learn-address.sh' \
  -u udp://openvpn-server
docker run -v $OVPN_VOLUME:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki nopass

docker run -v $OVPN_VOLUME:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full optimus nopass
docker run -v $OVPN_VOLUME:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full bumblebee nopass
docker run -v $OVPN_VOLUME:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full ratchet nopass

docker run -v $OVPN_VOLUME:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient optimus > optimus.ovpn
docker run -v $OVPN_VOLUME:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient bumblebee > bumblebee.ovpn
docker run -v $OVPN_VOLUME:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient ratchet > ratchet.ovpn
