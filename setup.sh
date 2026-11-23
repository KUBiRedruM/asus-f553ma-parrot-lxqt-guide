#!/usr/bin/env bash
# Automated Parrot OS (LXQt) Optimization Script for ASUS F553MA
set -e

echo "=== 1. Updating package lists ==="
sudo apt update

echo "=== 2. Installing TLP & ZRAM tools ==="
sudo apt install -y tlp zram-tools

echo "=== 3. Enabling TLP & ZRAM services ==="
sudo systemctl enable --now tlp
sudo systemctl enable --now zramswap

echo "=== 4. Optimizing kernel swappiness (vm.swappiness=10) ==="
if ! grep -q "^vm.swappiness=10" /etc/sysctl.conf; then
    echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
fi
sudo sysctl -p

echo "=== 5. Disabling unneeded background services ==="
# Note: Remove bluetooth.service below if you use Bluetooth devices
sudo systemctl disable --now bluetooth.service cups.service ModemManager.service || true
