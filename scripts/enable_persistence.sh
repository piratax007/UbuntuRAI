#!/usr/bin/env bash
set -euo pipefail

die(){ echo "ERROR: $*" >&2; exit 1; }
root(){ [[ $EUID -eq 0 ]] || die "Run as root (sudo)."; }
usage(){ echo "Usage: $0 /dev/sdX   (device, not a partition)"; exit 1; }

dev="${1:-}"; [[ -n "$dev" ]] || usage
[[ -b "$dev" ]] || die "$dev is not a block device"
[[ "$dev" =~ [0-9]$ ]] && die "Pass the device (e.g., /dev/sdX), not a partition (e.g., /dev/sdX1)."
root

echo ">>> Preparing $dev for a new persistence partition (casper-rw)..."

# Unmount anything mounted from the device
mapfile -t mpts < <(lsblk -nrpo MOUNTPOINT "$dev" | awk 'length')
for m in "${mpts[@]:-}"; do sudo umount -R "$m" || true; done

# Create a new partition that spans the largest free space
if command -v sgdisk >/dev/null 2>&1; then
  # Create Linux filesystem partition in largest free block
  sgdisk -n 0:0:0 -t 0:8300 -c 0:"casper-rw" "$dev"
  part="$(lsblk -nrpo NAME,TYPE "$dev" | awk '$2=="part"{p=$1} END{print p}')"
else
  # Fallback to parted
  start_s=$(parted -ms "$dev" unit s print | awk -F: 'END{print $3}' | sed 's/s$//')
  start_s=$((start_s+1))
  parted -s "$dev" unit s mkpart primary "${start_s}s" 100%
  part="$(lsblk -nrpo NAME,TYPE "$dev" | awk '$2=="part"{p=$1} END{print p}')"
fi

# Make ext4 and label as casper-rw
mkfs.ext4 -F -L casper-rw "$part"

echo ">>> Done. Created $part labeled 'casper-rw'."
echo ">>> Boot the USB and choose:  \"Try UbuntuRAI (persistent)\""
