# Troubleshooting (Phase 3)

## Symptom: socat exits immediately with EOF

- Cause: Pi closes TCP connection (ser2net not actually bound to working serial device)

Check on Pi:

```bash
sudo ss -lntp | grep ':15000'
ls -l /dev/follower /dev/ttyACM*
sudo systemctl status ser2net --no-pager
```

Check ser2net YAML formatting: **no spaces after commas**.

## Symptom: Missing motor ID 1 (but 2–6 found)

Likely causes:

- Servo/cable/power issue affecting first device in chain
- USB serial resets (watch kernel logs)
- Wi‑Fi jitter causing handshake packet loss

Actions:

- Disable USB autosuspend on Pi
- Use shorter USB cable / powered hub
- Reduce teleop to `--fps 5–10`
- Add retry + backoff in motor bus read/write paths

## Symptom: `There is no status packet!` (read)

Fix:

- Patch `_sync_read` to `num_retry >= 5` + `sleep(0.01)` backoff
- Run teleop with `--fps 10`

## Symptom: `failed to write Torque_Enable ... after 1 tries`

Fix:

- Add retry/backoff to the write path used for Torque_Enable (similar to `_sync_read` patch)
- Reduce `--fps`

## Symptom: USB disconnect/reconnect spam on Pi

Check:

```bash
sudo journalctl -k -n 120 --no-pager | grep -E "USB disconnect|ttyACM"
```

Mitigations:

- `usbcore.autosuspend=-1` in `/boot/firmware/cmdline.txt`
- Better power supply
- Better USB cable
- Powered hub
