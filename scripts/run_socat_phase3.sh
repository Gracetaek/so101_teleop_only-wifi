#!/usr/bin/env bash
set -euo pipefail

PI_IP="${1:?Usage: $0 <PI_IP> [PORT] }"
PORT="${2:-15000}"

sudo socat -d -d \
  PTY,link=/dev/ttyFOLLOWER,raw,echo=0,mode=666 \
  TCP:${PI_IP}:${PORT},nodelay,keepalive
