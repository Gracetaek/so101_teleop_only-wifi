#!/usr/bin/env bash
set -euo pipefail

FPS="${1:-10}"
LEADER_PORT="${2:-/dev/leader}"

lerobot-teleoperate \
  --fps "${FPS}" \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyFOLLOWER \
  --robot.id=follower \
  --teleop.type=so101_leader \
  --teleop.port="${LEADER_PORT}" \
  --teleop.id=leader
