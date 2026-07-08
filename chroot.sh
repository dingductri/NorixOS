#!/bin/bash
set -e

ROOTFS="${1:-build/NorixOS}"
shift || true

cleanup() {
    umount -lf "$ROOTFS/dev/pts" 2>/dev/null || true
    umount -lf "$ROOTFS/dev" 2>/dev/null || true
    umount -lf "$ROOTFS/proc" 2>/dev/null || true
    umount -lf "$ROOTFS/sys" 2>/dev/null || true
    umount -lf "$ROOTFS/run" 2>/dev/null || true
}

trap cleanup EXIT

mountpoint -q "$ROOTFS/dev"     || mount --bind /dev "$ROOTFS/dev"
mountpoint -q "$ROOTFS/dev/pts" || mount --bind /dev/pts "$ROOTFS/dev/pts"
mountpoint -q "$ROOTFS/proc"    || mount --bind /proc "$ROOTFS/proc"
mountpoint -q "$ROOTFS/sys"     || mount --bind /sys "$ROOTFS/sys"
mountpoint -q "$ROOTFS/run"     || mount --bind /run "$ROOTFS/run"

cp -L /etc/resolv.conf "$ROOTFS/etc/resolv.conf" 2>/dev/null || true

if [ $# -gt 0 ]; then
    chroot "$ROOTFS" /bin/bash -lc "$*"
else
    exec chroot "$ROOTFS" /bin/bash -l
fi
