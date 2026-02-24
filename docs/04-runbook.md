# Phase 3 Runbook (Full Wireless)

## Variables

- `PI_IP`: Raspberry Pi Wi‑Fi IP (example: `192.168.10.85`)
- `SER2NET_PORT`: `15000`

## Step 1 — Pi: confirm ser2net listening

```bash
sudo ss -lntp | grep ':15000'
ls -l /dev/follower
```

## Step 2 — Laptop: start socat (direct TCP)

Run in its own terminal and keep it open:

```bash
sudo socat -d -d \
  PTY,link=/dev/ttyFOLLOWER,raw,echo=0,mode=666 \
  TCP:${PI_IP}:15000,nodelay,keepalive
```

Expected: socat stays running (no immediate EOF).

Verify:

```bash
ls -l /dev/ttyFOLLOWER
```

## Step 3 — Laptop: run teleop

```bash
lerobot-teleoperate \
  --fps 10 \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyFOLLOWER \
  --robot.id=follower \
  --teleop.type=so101_leader \
  --teleop.port=/dev/leader \
  --teleop.id=leader
```

## Acceptance test

- Run continuously for 10–15 minutes.
- Verify no aborts.

## If you still see aborts

- Ensure `_sync_read` default `num_retry` is >= 5 and includes `sleep(0.01)` backoff.
- Lower loop: `--fps 5`.
- Check for USB disconnects on Pi: `sudo journalctl -k -n 80 --no-pager | grep -E "USB disconnect|ttyACM"`.

## Publishing to GitHub

This environment cannot create/push repos via connector.

To publish:

```bash
# on your laptop
mkdir so101_teleop_phase3_full_wifi
# copy the folder contents from this repo package

git init
# add remote created on GitHub
# git remote add origin git@github.com:<user>/<repo>.git

git add -A
ig commit -m "Add Phase 3 full Wi-Fi teleop guide"
ig push -u origin main
```

(Use GitHub UI to create the repo first.)
