# SO101 Teleop Phase 3 — Full Wireless (Same Wi‑Fi)

Phase 3 runs **both** the laptop (leader + LeRobot) and the Raspberry Pi (follower + ser2net) on the **same Wi‑Fi router**.

This repo is a portfolio-ready, reproducible guide for:

- Pi on Wi‑Fi (`wlan0`) + follower arm via USB serial
- Laptop on Wi‑Fi + leader arm via USB serial
- `ser2net` on Pi exposes follower serial over TCP
- `socat` on laptop creates a local virtual serial `/dev/ttyFOLLOWER`
- LeRobot teleop runs on laptop using:
  - leader: `/dev/leader` (udev symlink)
  - follower: `/dev/ttyFOLLOWER`

> **Why Phase 3 is harder**: Wi‑Fi jitter + occasional USB resets can cause motor packets to time out. This repo includes the reliability patches used to avoid aborts (retry + backoff).

---

## Repo structure

```
so101_teleop_phase3/
├── README.md
├── docs/
│   ├── 01-architecture.md
│   ├── 02-pi-setup.md
│   ├── 03-laptop-setup.md
│   ├── 04-runbook.md
│   ├── 05-udev-symlinks.md
│   ├── 06-troubleshooting.md
│   └── 07-patch-notes.md
├── configs/
│   └── ser2net.yaml
└── scripts/
    ├── run_socat_phase3.sh
    └── run_teleop_phase3.sh
```

---

## Quick Start

1. **Pi**: ensure `/dev/follower` exists and `ser2net` listens on `:15000`.
2. **Laptop**: run `socat` to create `/dev/ttyFOLLOWER` that connects to `Pi_IP:15000`.
3. **Laptop**: run `lerobot-teleoperate --fps 10 ...` using `/dev/ttyFOLLOWER` + `/dev/leader`.

See `docs/04-runbook.md` for the exact command sequence.

---

## Note about GitHub creation

Your GitHub connector is read-only in this environment, so I cannot create or push a new GitHub repository automatically.

To publish this as a new repo:

1. Create a repo on GitHub (e.g., `so101_teleop_phase3_full_wifi`).
2. Upload the contents of this folder.

(Instructions included in `docs/04-runbook.md`.)
