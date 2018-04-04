#!/bin/bash
set -e

OVPN_VOLUME="ovpn-data"
IMAGE_NAME="personal-vpn:latest"

docker volume rm -f "${OVPN_VOLUME}"
docker volume create "${OVPN_VOLUME}"

docker run -v $OVPN_VOLUME:/etc/openvpn --rm ${IMAGE_NAME} ovpn_genconfig \
  -c \
  -n 172.16.238.254 \
  -p "dhcp-option DOMAIN-SEARCH testing.local" \
  -e 'script-security 2' \
  -e 'learn-address /usr/local/bin/ovpn_learn_address' \
  -u udp://openvpn-server
docker run -v $OVPN_VOLUME:/etc/openvpn --rm -it ${IMAGE_NAME} ovpn_initpki nopass

docker run -v $OVPN_VOLUME:/etc/openvpn --rm -it ${IMAGE_NAME} easyrsa build-client-full optimus nopass
docker run -v $OVPN_VOLUME:/etc/openvpn --rm -it ${IMAGE_NAME} easyrsa build-client-full bumblebee nopass
docker run -v $OVPN_VOLUME:/etc/openvpn --rm -it ${IMAGE_NAME} easyrsa build-client-full ratchet nopass

docker run -v $OVPN_VOLUME:/etc/openvpn --rm ${IMAGE_NAME} ovpn_getclient optimus > optimus.ovpn
docker run -v $OVPN_VOLUME:/etc/openvpn --rm ${IMAGE_NAME} ovpn_getclient bumblebee > bumblebee.ovpn
docker run -v $OVPN_VOLUME:/etc/openvpn --rm ${IMAGE_NAME} ovpn_getclient ratchet > ratchet.ovpn
