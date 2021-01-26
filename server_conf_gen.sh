#!/bin/bash

set -ue

conf=$(cat <<EOS
[Interface]
Address = 10.0.1.1/8
ListenPort = 12345
PrivateKey = MIYD/0ELFk+5S5+LjQ7c3WSLkgiQb/TlwIQPA5MLiW4=
EOS
)

while read -r line; do
  allowed_ip=$(echo "$line" | cut -d , -f 1)
  endpoint_port=$(echo "$line" | cut -d , -f 2)
  public_key=$(echo "$line" | cut -d , -f 4)

  conf=$(cat <<EOS
$conf

[Peer]
PublicKey = $public_key
AllowedIPs = $allowed_ip
Endpoint = 192.18.0.114:${endpoint_port}
EOS
)
done

echo "$conf"
