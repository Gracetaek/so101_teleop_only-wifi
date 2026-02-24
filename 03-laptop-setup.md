# Laptop Setup (Wi‑Fi + socat + LeRobot)

## 1) Create stable leader symlink (`/dev/leader`)

Identify leader device:

```bash
udevadm info -q property -n /dev/ttyACM0 | egrep 'ID_SERIAL_SHORT|ID_PATH|ID_SERIAL'
```

Create udev rule (replace SERIAL_HERE):

```bash
sudo nano /etc/udev/rules.d/99-so101.rules
```

```udev
SUBSYSTEM=="tty", ATTRS{serial}=="SERIAL_HERE", SYMLINK+="leader", GROUP="dialout", MODE="0660"
```

Apply:

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
# replug leader USB
ls -l /dev/leader
```

## 2) Install socat

```bash
sudo apt update
sudo apt install -y socat
```

## 3) Ensure your user is in dialout

```bash
groups | grep dialout || sudo usermod -aG dialout $USER
# log out/in if you just added
```

## 4) LeRobot

Use your existing LeRobot checkout and venv:

- `/home/ethan/lerobot/.venv/bin/lerobot-teleoperate`
- Source code: `/home/ethan/lerobot/src/lerobot`

Recommended runtime flags in Phase 3:

- `--fps 10`

And apply the retry/backoff patch for `_sync_read` (see `docs/07-patch-notes.md`).
