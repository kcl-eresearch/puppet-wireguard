#!/usr/bin/python3

import datetime
import subprocess
import sys
import yaml

WG = "/usr/bin/wg"
NOW = datetime.datetime.now()

try:
    output = subprocess.run([WG, "show", "all", "dump"], text=True, capture_output=True)
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)

if output.returncode != 0:
    print(f"Error: {output.stderr}")
    sys.exit(1)

interfaces = {}

for line in output.stdout.splitlines():
    fields = line.split("\t")
    if len(fields) == 5:
        interface = {
            "name": fields[0],
            "public_key": fields[1],
            "private_key": fields[2],
            "listen_port": int(fields[3]),
            "fwmark": fields[4],
            "peers": {}
        }
        interfaces[fields[0]] = interface
    
    elif len(fields) == 9:
        peer = {
            "interface": fields[0],
            "public_key": fields[1],
            "preshared_key": fields[2],
            "endpoint": fields[3],
            "allowed_ips": fields[4].split(","),
            "latest_handshake": datetime.datetime.utcfromtimestamp(int(fields[5])).strftime("%Y-%m-%dT%H:%M:%SZ"),
            "transfer_rx": int(fields[6]),
            "transfer_tx": int(fields[7]),
            "persistent_keepalive": int(fields[8]),
        }

        interfaces[fields[0]]["peers"][fields[1]] = peer

print(yaml.dump({"wireguard_interfaces": interfaces}, default_flow_style=False))
