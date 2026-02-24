# Architecture (Phase 3: Full Wireless)

## Topology

```
Leader Arm (USB) -> Laptop (LeRobot) -> /dev/ttyFOLLOWER (PTY)
                                        |
                                        +-> socat -> TCP -> Pi:15000 -> ser2net -> /dev/follower (USB) -> Follower Arm

Laptop Wi‑Fi (192.168.10.x)  <==== same Wi‑Fi router ==== >  Pi Wi‑Fi (192.168.10.85)
```

## Components

- **Raspberry Pi (Wi‑Fi)**
  - Connects to same router as laptop
  - USB serial to follower arm (typically `/dev/ttyACM0`)
  - udev symlink: `/dev/follower`
  - `ser2net` exposes `/dev/follower` at TCP `0.0.0.0:15000`

- **Laptop (Wi‑Fi)**
  - USB serial to leader arm (typically `/dev/ttyACM0`)
  - udev symlink: `/dev/leader`
  - `socat` creates `/dev/ttyFOLLOWER` and forwards to `Pi_IP:15000`
  - LeRobot teleop opens:
    - leader: `/dev/leader`
    - follower: `/dev/ttyFOLLOWER`

## Why Phase 3 needs robustness

Wi‑Fi introduces jitter (e.g., 50–150 ms spikes) and occasional packet loss. USB serial can also reset. The default LeRobot bus methods can abort on a single missed status packet.

Mitigations:

- Lower loop rate: `--fps 10`
- Add retry + backoff in sync reads (and torque enable writes if needed)
- Disable USB autosuspend on Pi
- Use stable udev symlinks on both machines
