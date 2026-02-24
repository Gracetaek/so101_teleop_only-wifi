# udev Symlinks (leader / follower)

Using `/dev/ttyACM0` directly is brittle because numbering can change after replug/reboot.

Create stable symlinks:

- Laptop leader: `/dev/leader`
- Pi follower: `/dev/follower`

## Pi (follower)

1) Identify serial:

```bash
sudo udevadm info -q property -n /dev/ttyACM0 | egrep 'ID_SERIAL_SHORT|ID_SERIAL'
```

2) Rule:

```bash
sudo nano /etc/udev/rules.d/99-so101.rules
```

```udev
SUBSYSTEM=="tty", ATTRS{serial}=="SERIAL_HERE", SYMLINK+="follower", GROUP="dialout", MODE="0660"
```

3) Apply:

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
# replug USB
ls -l /dev/follower
```

## Laptop (leader)

Same pattern but symlink name is `leader`.

If `ATTRS{serial}` is missing, match on `ENV{ID_PATH}` (stable per USB port):

```bash
udevadm info -q property -n /dev/ttyACM0 | egrep 'ID_PATH'
```

Rule:

```udev
SUBSYSTEM=="tty", ENV{ID_PATH}=="PATH_HERE", SYMLINK+="leader", GROUP="dialout", MODE="0660"
```
