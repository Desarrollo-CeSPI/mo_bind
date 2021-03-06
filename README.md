# mo_bind-cookbook

Installs and configures BIND using databags.

## Supported Platforms

Ubuntu. Should work in other platforms with some minor customizations
(directories, packages names).

## Usage

This cookbook uses data bags to define DNS zones, with each zone in a databag.
By default, information is retrieved from items located in data bag named
dns_zones. This can be changed by setting the corresponding attribute.

### Data bags

To define a new zone:

```
knife data bag create dns_zones zone_name
```

```json
{
  "id": "zone_name",
  "domain": "example",
  "includes": [
    "subdomain1.example",
    "subdomain2.example"
  ],
  "zone_definition": {
    "masters": [
      "192.168.0.10"
    ],
    "slaves": [
      "192.168.0.11"
    ],
    "options": {
      "allow-transfer": [
        "192.168.0.11"
      ],
      "allow-query": [
        "any"
      ]
    }
  },
  "zone_database": {
    "ttl": 300,
    "serial": 2015090700,
    "refresh": 28800,
    "retry": 900,
    "expire": 3600,
    "negative-ttl": 3600,
    "root": {
      "mx": [
        "5 mx1.example",
        "10 mx2.example"
      ],
      "ns": [
        "ns1.example",
        "ns2.example"
      ],
      "a": "192.168.0.12",
      "txt": "'v=spf1 mx ip4:192.168.0.13 mx:mx1.example -all'"
    },
    "registers": {
      "a": {
        "ns1": "192.168.0.10",
        "ns2": {
          "value": "192.168.0.11",
          "ttl": 3600
        }
        "mx1": "192.168.0.13"
      },
      "cname": {
        "dns1": "ns1"
        "dns2": "ns2"
      }
    }
  }
}
```

* Domain parameter is optional, if not present id is used as the domain name.
* Includes parameters is also optional. It is used to reference another data bag
  item in the same data bag where additional registers are specified. Those data
  bag items referenced there must just define registers, in the same way it is
  done for the main data bag item, starting at the registers key.

Data bag is divided in two main sections:

* *zone_definition*: this section matches information in named.conf.local.
* *zone_database*: this section is the one that goes in the zone database file.

### Recipe usage

There is just a default recipe which applies to both, master and slave servers.
There is no need to specify if a server will act as a master or a slave. Servers
will know there role for a specific zone based on the IP address specified in
masters and slaves arrays.

The server which runs default recipe will first search for every zone in which
its IP address appears either as a master or a slave and will set up the zone.
If the server IP address is present in both arrays for a specific zone the server
will be configured as master for that zone.

In the case of a server being a master for a zone it will write the zone
database in /etc/bind/domain_zones (unless other path is specified in the
corresponding attributes). For those zones a server is a slave it will store the
cache database in /var/lib/bind/cache (unless other path is specified in the
corresponding attributes).

## License and Authors

* Author:: Christian Rodriguez (<chrodriguez@gmail.com>)
* Author:: Leandro Di Tommaso (<leandro.ditommaso@mikroways.net>)
