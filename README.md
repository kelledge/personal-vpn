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
The etcd plugin is configured to resolve the testing.local domain currently.

Add `example.testing.local` record:
```
curl http://etcd:2379/v2/keys/coredns/local/testing/example -XPUT -d value='{"host": "1.2.3.6"}'
```

Add `example.testing.local` reverse record:
```
curl -XPUT http://etcd:4001/v2/keys/coredns/arpa/in-addr/1/2/3/6 -d value='{"host":"example.testing.local."}'
```

Remove `example.testing.local` record:
```
curl http://etcd:2379/v2/keys/coredns/local/testing/example -XDELETE
```
