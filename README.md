# mo_bind-cookbook

**This cookbook is currently under development**

Installs and configures BIND.

## Supported Platforms

Ubuntu

## Usage

This cookbook uses data bags to define DNS zones, with each zone in a databag.
By default, information is retrieved from items located in data bag named
dns_zones. This can be changed by setting the corresponding attribute.

To define a new zone:

```
knife data bag create dns_zones zone_name
```

```json
{
  "id": "zone_name",
  "domain": "domain_name",
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
  }
}
```

Domain parameter is optional, if not present id is used as the domain name.

## License and Authors

* Author:: Christian Rodriguez (<chrodriguez@gmail.com>)
* Author:: Leandro Di Tommaso (<leandro.ditommaso@mikroways.net>)
