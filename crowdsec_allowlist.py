#!/usr/bin/env -S uv run --script

# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "click",
#     "click-log",
#     "durationpy",
#     "ipaddress",
#     "logging",
#     "mysql-connector-python",
#     "PyYAML"
# ]
# ///

import click
import click_log
import datetime
import durationpy
import ipaddress
import logging
import mysql.connector
import yaml


logger = logging.getLogger(__name__)
click_log.basic_config(logger)


def load_whitelist_cidrs(yaml_path):
    with open(yaml_path, "r") as f:
        data = yaml.safe_load(f)

    return data["whitelist"]["cidr"]


def load_crowdsec_config(crowdsec_config_path):  # pragma: no cover
    """
    Load the Crowdsec configuration file.

    """
    with open(crowdsec_config_path, "r") as f:
        return yaml.safe_load(f)


def addr2ints(any_ip):
    if "/" in any_ip:
        net = ipaddress.ip_network(any_ip, strict=False)
        return range2ints(net)
    ip = ipaddress.ip_address(any_ip)
    size, hi, lo = ip2ints(ip)
    return size, hi, lo, hi, lo


MAX_INT64 = (1 << 63) - 1
MAX_UINT64 = (1 << 64) - 1


def uint2int(u):
    if u == MAX_INT64:
        return 0
    elif u == MAX_UINT64:
        return MAX_INT64
    elif u > MAX_INT64:
        return int(u - MAX_INT64)
    else:
        return int(u) - MAX_INT64


def ip2ints(pip):
    """
    Mirrors the Go IP2Ints:
      - returns (size, network_part, suffix_part)
      - size is 4 for IPv4, 16 for IPv6
      - parts are signed int64 equivalents of the two uint64 halves
    """
    b = pip.packed
    if len(b) == 4:
        nw32 = int.from_bytes(b, "big")
        return 4, uint2int(nw32), uint2int(0)
    elif len(b) == 16:
        nw = int.from_bytes(b[:8], "big")
        sfx = int.from_bytes(b[8:], "big")
        return 16, uint2int(nw), uint2int(sfx)
    else:
        raise ValueError(f"unexpected len {len(b)} for {pip}")


def range2ints(net):
    size1, hi1, lo1 = ip2ints(net.network_address)
    size2, hi2, lo2 = ip2ints(net.broadcast_address)
    if size1 != size2:
        raise ValueError(f"inconsistent size: {size1} vs {size2}")
    return size1, hi1, lo1, hi2, lo2


@click_log.simple_verbosity_option(logger)
def get_allow_list_id(db_config, name):
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor()
    cursor.execute("SELECT id FROM allow_lists WHERE name=%s", (name,))
    row = cursor.fetchone()
    cursor.close()
    conn.close()
    if not row:
        raise click.BadParameter(f"No allow list named '{name}'")
    return row[0]


@click_log.simple_verbosity_option(logger)
def update_allowlist(allow_list_id, cidrs, db_config, expire_delta=86400):
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor()

    # now = datetime.datetime.utcnow()  # FIXME
    now = datetime.datetime.now(datetime.timezone.utc)
    expires_at = now + expire_delta

    select_sql = "SELECT id FROM allow_list_items WHERE value=%s LIMIT 1"
    insert_sql = """
        INSERT INTO allow_list_items
          (created_at, updated_at, expires_at, comment, value,
           start_ip, end_ip, start_suffix, end_suffix, ip_size)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """
    select_link_sql = """
        SELECT 1 FROM allow_list_allowlist_items
         WHERE allow_list_id=%s AND allow_list_item_id=%s LIMIT 1
    """
    insert_link_sql = """
        INSERT INTO allow_list_allowlist_items
          (allow_list_id, allow_list_item_id)
        VALUES (%s, %s)
    """
    update_item_sql = """
        UPDATE allow_list_items
        SET updated_at=%s, expires_at=%s
        WHERE id=%s
    """

    for cidr in cidrs:
        value = cidr[:-3] if cidr.endswith("/32") else cidr
        cidr = value

        cursor.execute(select_sql, (cidr,))
        row = cursor.fetchone()

        if row:
            item_id = row[0]
            cursor.execute(update_item_sql, (now, expires_at, item_id))
            logger.debug(f"Updated expires_at for item_id={item_id} to {expires_at}")
        else:
            size, start_ip, start_sfx, end_ip, end_sfx = addr2ints(cidr)
            params = (
                now,
                now,
                expires_at,
                "",
                cidr,
                start_ip,
                end_ip,
                start_sfx,
                end_sfx,
                size,
            )

            logger.debug(f"executing with params: {params}")  # debug print
            cursor.execute(insert_sql, params)
            item_id = cursor.lastrowid
            # logger.debug("cursor.statement", cursor.statement)
            # formatted = format_query(insert_sql, params)
            # print("Debug: formatted SQL:")
            # print(formatted)

        logger.debug(f"item_id={item_id}")
        cursor.execute(select_link_sql, (allow_list_id, item_id))

        if not cursor.fetchone():
            cursor.execute(insert_link_sql, (allow_list_id, item_id))
            logger.info(f"Linked item_id={item_id} to allow_list_id={allow_list_id}")
    conn.commit()
    cursor.close()
    conn.close()


@click.command()
@click.argument("whitelist_yaml", type=click.Path(exists=True), nargs=-1, required=True)
@click.option(
    "--crowdsec-config",
    "-c",
    default="/etc/crowdsec/config.yaml",
    type=click.Path(exists=True),
    help="Path to the CrowdSec configuration file with the DB connection details (default: /etc/crowdsec/config.yaml)",
)
@click.option(
    "--allowlist-name",
    "-l",
    required=True,
    help="Name of the allowlist to import into",
)
@click.option(
    "--expire",
    "-e",
    required=False,
    default="24h",
    help="Expiration time for the allow list items (default: 24h)",
)
@click_log.simple_verbosity_option(logger)
def import_allowlist(crowdsec_config, whitelist_yaml, allowlist_name, expire):
    crowdsec_config_data = load_crowdsec_config(crowdsec_config)

    db_config = {
        "host": crowdsec_config_data["db_config"]["host"],
        "user": crowdsec_config_data["db_config"]["user"],
        "password": crowdsec_config_data["db_config"]["password"],
        "database": crowdsec_config_data["db_config"]["db_name"],
    }

    allow_list_id = get_allow_list_id(db_config, allowlist_name)
    expire_delta = durationpy.from_str(expire)

    for yaml_path in whitelist_yaml:
        logger.info(f"Importing allowlist from {yaml_path}...")
        cidrs = load_whitelist_cidrs(yaml_path)
        update_allowlist(allow_list_id, cidrs, db_config, expire_delta)


if __name__ == "__main__":
    import_allowlist()
