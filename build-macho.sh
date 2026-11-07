#!/bin/bash
# Run inside the folder that has: usr/share/m1n1/m1n1-idevice.macho, boot/vmlinuz,
# boot/dtbs/apple/s8000-n69u.dtb and initramfs.cpio.gz
INITFS=initramfs.cpio.gz
SIZE=$(stat -c%s $INITFS)
{
  cat usr/share/m1n1/m1n1-idevice.macho
  printf 'm1n1_initramfs'
  python3 -c "import sys;sys.stdout.buffer.write(int($SIZE).to_bytes(4,'little'))"
  cat $INITFS
  cat boot/vmlinuz
  cat boot/dtbs/apple/s8000-n69u.dtb
  echo 'chosen.bootargs=console=tty0 rdinit=/init panic=0 loglevel=4'
} > m1n1-linux.macho
