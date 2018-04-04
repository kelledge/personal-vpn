FROM kylemanna/openvpn

RUN apk add --update python3 && \
    pip3 install python-etcd

ADD ./ovpn_learn_address /usr/local/bin/ovpn_learn_address
