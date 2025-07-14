# Import CrowdSec YAML whitelists into MySQL/MariaDB

This script imports IP addresses from [CrowdSec whitelists][1] into
[CrowdSec allowlist][2] directly into its DB. Only MySQL/MariaDB is supported.

If an IP is already present in the `allowlist`, then its expiration time is
updated (default=24h). This allows periodic refresh of the `allowlist` from
external sources. The IPs that are removed from the whitelist aren't removed
from the `allowlist`, but don't get their expiration time updated, so they get
inactive after the expiration period.

WARNING: When a new IP is added to an `allowlist`, decisions matching this IP
are NOT removed.

## Install

Use [`uv`][3] to install dependencies (requirements are inlined in the script
itself, see [PEP 723][4]):

```
uv sync --active --script crowdsec_allowlist.py
```

## Usage

```
Usage: crowdsec_allowlist.py [OPTIONS] WHITELIST_YAML [WHITELIST_YAML …]


Options:
  -c, --crowdsec-config PATH  Path to the CrowdSec configuration file with the
                              DB connection details (default:
                              /etc/crowdsec/config.yaml)
  -l, --allowlist-name TEXT   Name of the allowlist to import into  [required]
  -e, --expire TEXT           Expiration time for the allow list items
                              (default: 24h)
  -v, --verbosity LVL         Either CRITICAL, ERROR, WARNING, INFO or DEBUG
  --help                      Show this message and exit.
```

Example command:

```
crowdsec_allowlist.py -v DEBUG -c config.yaml -l default 01-local-whitelist.yaml\
  02-cloudfront-whitelist.yaml
```

[1]: https://docs.crowdsec.net/docs/next/log_processor/whitelist/intro
[2]: https://docs.crowdsec.net/docs/next/local_api/centralized_allowlists/
[3]: https://docs.astral.sh/uv/
[4]: https://peps.python.org/pep-0723/

Author:: Alex L. Demidov (<alexeydemidov@gmail.com>)
