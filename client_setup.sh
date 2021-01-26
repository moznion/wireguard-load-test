#!/bin/bash

set -e

if [ -n "$DO_INIT" ]; then
  rm -rf /usr/local/wireguard/config/peer*
fi

for i in {1..253}; do
  private_key="$(wg genkey)"
  dir="/usr/local/wireguard/config/peer${i}/"

  local_address="10.0.2.$(( 1 + i ))/32"

  mkdir -p "$dir"
  cat <<EOS > "${dir}/wg0.conf"
[Interface]
PrivateKey = $private_key
Address = $local_address
ListenPort = 51820

[Peer]
PublicKey = eLeHBFPs/b0/oh1yeRBdByAQyDdYzeAfjGB4iYiwJAc=
AllowedIPs = 10.0.1.1/32
Endpoint = 192.18.0.70:12345
EOS

  echo "${local_address},$(( 10000 + i )),${private_key},$(wg pubkey <<< "$private_key")"
done

