# Personal VPN

## DNS
The idea is to use etcd and coredns to provide dynamic DNS based on common names
of clients connecting to the VPN.

The `learn-address` configuration option of the openvpn server will add and
remove the keys from the etcd key/value store. This key/value store is providing
the resolution information to coredns.

The openvpn server will also need to be configured to specify the coredns server
as the dns server using the push options.


## Simple Testing
All records are nested under the `skydns` key as currently configured. This just
makes following examples easier for now. In the future this will be the local
domain that I find best fits the vpn.

The etcd plugin is configured to resolve the skydns.local domain currently.

Add `example.skydns.local` record:
```
curl http://etcd:2379/v2/keys/skydns/local/skydns/example -XPUT \
  -d value='{"host": "1.2.3.6"}'
```

Add `example.skydns.local` reverse record:
```
curl -XPUT http://etcd:4001/v2/keys/skydns/arpa/in-addr/1/2/3/6 \
  -d value='{"host":"example.skydns.local."}'
```

Remove `example.skydns.local` record:
```
curl http://etcd:2379/v2/keys/skydns/local/skydns/example -XDELETE
```
