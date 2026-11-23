# ASUS F553MA — Parrot OS LXQt Optimization & Power Guide

A verified setup, power management, and performance tuning guide for running **Parrot OS (LXQt + `xfwm4`)** smoothly on a 2014 **ASUS F553MA** (Intel Bay Trail / DDR3L hardware).

## Hardware & Environment
* **Model:** ASUS F553MA (X453/X553 platform)
* **Processor & Graphics:** Intel Celeron / Pentium (Bay Trail) + Intel HD Graphics
* **Memory:** DDR3L RAM
* **Battery Module:** `X453-42` (`B21N1329`)
* **OS & Desktop:** Parrot OS (LXQt session with `xfwm4` window manager)

## Quick Automated Setup
Run all power and performance tweaks automatically:
```bash
git clone https://github.com
cd asus-f553ma-parrot-lxqt-guide
bash setup.sh
```

---


---

## 1. Screen Flickering & AC Power Management

### Root Cause
On aging 2014 lithium-ion batteries (e.g., ~62% capacity), high internal cell resistance causes voltage drops when unplugged, triggering backlight flickering across both Windows and Linux. Furthermore, the ASUS F553MA EC firmware does not support software charge thresholds (`natacpi` / `charge_control_end_threshold`).

### Safe AC Power Operation
Running continuously on AC power is safe. Once charged, the F553MA motherboard hardware circuit automatically switches battery `status` to `Not charging` (`0 mW` draw) and powers the laptop directly from the AC adapter without overcharging the battery.

### Install TLP for Thermal & Power Efficiency
Even without charge thresholds, `tlp` optimizes CPU frequency scaling and PCIe/USB power states to keep temperatures low:
```bash
sudo apt update && sudo apt install tlp -y
sudo systemctl enable --now tlp
sudo tlp-stat -b
```

---

## 2. Performance & RAM Tweaks

### Enable ZRAM Compressed Swap
Expands usable memory capacity on DDR3L systems by compressing swap data in RAM rather than hitting disk I/O:
```bash
sudo apt install zram-tools -y
sudo systemctl enable --now zramswap
```

### Optimize Kernel Swappiness
Prioritize keeping active applications in physical RAM longer:
```bash
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### Disable Unneeded Background Daemons
Free up boot time and idle RAM (omit `bluetooth.service` if you use Bluetooth peripherals):
```bash
sudo systemctl disable --now bluetooth.service cups.service ModemManager.service
```

---

## 3. LXQt & `xfwm4` Window Manager Tweaks

### Verify `xfwm4` Display Compositing is Disabled
Parrot OS pairs the lightweight LXQt shell with the `xfwm4` window manager. Ensuring display compositing is disabled eliminates window shadow and transparency overhead on 2014 Intel HD Graphics:
1. Open **Preferences → LXQt Settings → Window Manager Tweaks** (or run `xfwm4-tweaks-settings` in terminal).
2. Navigate to the **Compositor** tab.
3. Confirm **Enable display compositing** is **unchecked** (all sliders greyed out).

---

## License
Distributed under the MIT License.
