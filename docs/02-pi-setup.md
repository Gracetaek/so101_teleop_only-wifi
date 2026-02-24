# Pi Setup (Wi‑Fi + ser2net)

## 1) Confirm Wi‑Fi IP and routing

```bash
ip a | grep -A2 wlan0
ip route
```

You should see `default via <router>` on `wlan0` and a `192.168.10.x/24` address.

## 2) Create stable follower symlink (`/dev/follower`)

Find the serial number for the adapter:

```bash
sudo udevadm info -q property -n /dev/ttyACM0 | egrep 'ID_SERIAL_SHORT|ID_SERIAL'
```

Create udev rule (example uses `5A7A017106`):

```bash
sudo nano /etc/udev/rules.d/99-so101.rules
```

```udev
SUBSYSTEM=="tty", ATTRS{serial}=="5A7A017106", SYMLINK+="follower", GROUP="dialout", MODE="0660"
```

Apply:

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
# replug USB recommended
ls -l /dev/follower
```

## 3) Disable USB autosuspend (prevents random ttyACM disconnects)

Temporary:

```bash
sudo sh -c 'echo -1 > /sys/module/usbcore/parameters/autosuspend'
```

Persistent:

```bash
sudo nano /boot/firmware/cmdline.txt
# add (same line):
# usbcore.autosuspend=-1
sudo reboot
```

## 4) Install and configure ser2net

```bash
sudo apt update
sudo apt install -y ser2net
```

Edit `/etc/ser2net.yaml` (see `configs/ser2net.yaml`):

- **No spaces after commas**.
- Use `/dev/follower`.

Restart and verify:

```bash
sudo systemctl enable --now ser2net
sudo systemctl restart ser2net
sudo ss -lntp | grep ':15000'
```

## 5) Verify reachability from laptop

From laptop:

```bash
ping -c 3 <PI_IP>
nc -vz <PI_IP> 15000
```
