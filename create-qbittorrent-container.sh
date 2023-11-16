#!/usr/bin/env bash
set -e

MY_PATH="/path/to/your/mounted/volume"

export \
  QBT_EULA=accept \
  QBT_VERSION=latest \
  QBT_WEBUI_PORT=8080 \
  QBT_CONFIG_PATH="$MY_PATH/.qbittorrent/config" \
  QBT_DOWNLOADS_PATH="$MY_PATH/downloads"

podman run \
  -d \
  -t \
  --name qbittorrent-nox \
  --read-only \
  --restart always \
  --stop-timeout 1800 \
  --tmpfs /tmp \
  -e QBT_EULA \
  -e QBT_WEBUI_PORT \
  --net host \
  --cap-add NET_RAW \
  -v "$QBT_CONFIG_PATH":/config \
  -v "$QBT_DOWNLOADS_PATH":/downloads \
  qbittorrentofficial/qbittorrent-nox:${QBT_VERSION}

# Note:
# --net host: allow IPv6 accesses and UPnP ports
# --cap-add NET_RAW: allow ping

podman generate systemd qbittorrent-nox > /etc/systemd/system/podman-container-qbittorrent-nox.service
systemctl daemon-reload