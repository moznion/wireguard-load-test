#!/bin/bash

set -eu

runner_script=""

for i in {1..253}; do
  runner_script=$(cat <<EOS
$runner_script

sudo docker run --rm -d \\
  --name=wireguard_peer${i} \\
  --cap-add=NET_ADMIN \\
  --cap-add=SYS_MODULE \\
  -e PUID=1000 \\
  -e PGID=1000 \\
  -e TZ=Asia/Tokyo \\
  -e SERVERPORT=51820 \\
  -p $(( 10000 + i )):51820/udp \\
  -v /usr/local/wireguard/config/peer${i}:/config \\
  -v /lib/modules:/lib/modules \\
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \\
  ghcr.io/linuxserver/wireguard \\
  ping 10.0.1.1
EOS
)
done

echo "$runner_script"
