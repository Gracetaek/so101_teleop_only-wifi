# Patch Notes (Phase 3 Reliability)

## Problem

In full wireless mode, occasional latency spikes can cause LeRobot to abort on:

- sync reads: `There is no status packet!`
- torque enable writes: `failed to write Torque_Enable ... after 1 tries`

## Applied patch (sync read)

In `lerobot/src/lerobot/motors/motors_bus.py`:

- `sync_read(..., num_retry: int = 5)`
- `_sync_read(..., num_retry: int = 5)`
- add `time.sleep(0.01)` backoff between failed attempts

This makes the bus tolerant to transient Wi‑Fi jitter.

## Runtime settings

- Run teleop at lower rate:

```bash
lerobot-teleoperate --fps 10 ...
```

- If still unstable, try `--fps 5`.

## Next recommended patch (Torque_Enable writes)

If you see Torque_Enable write failures, apply the same retry+backoff pattern in the write path used for Torque_Enable.

## Safety note

Retries improve robustness but can increase worst-case latency. Combine with conservative motion limits and a watchdog/safe-stop strategy for demos.
