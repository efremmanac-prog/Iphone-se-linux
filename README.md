# Iphone-se-linux
Booting Linux 7.0.4 (postmarketOS kernel) on iPhone SE 1st gen (A9) via checkm8, remote_boot and m1n1

# Linux on iPhone SE 1st gen (A9)

Booting the postmarketOS 16k kernel (7.0.4) to userspace on an iPhone SE 1st gen
(iPhone8,4, CPID 0x8000, board n69uap), tethered via checkm8.

**Status:** kernel boots into a custom busybox initramfs; the framebuffer console
works. USB gadget networking does not work yet (`g_multi: couldn't find an
available UDC`, `failed to start g_multi: -22`).

## Setup
- Host: Linux Mint live USB
- `remote_boot` from HoolockLinux
- `m1n1-apple-idevice` 1.5.0, `linux-postmarketos-apple-16k` 7.0.4,
  `postmarketos-initramfs` from the postmarketOS v26.06 aarch64 repo
- Boot object built as in the postmarketOS "Apple Generic iDevice" wiki page:
  m1n1 macho + initramfs + kernel + `s8000-n69u.dtb` + `chosen.bootargs`

## Files
- `init`: the initramfs init script
- `build-macho.sh`: builds `m1n1-linux.macho`
- `remoteboot-model-fix.patch`: sets MODEL and PRODUCT by hand in `remoteboot.sh`

## Problems I hit
1. Submodules use `git@github.com:` URLs, so cloning fails without an SSH key.
   Fix: `git config --global url."https://github.com/".insteadOf "git@github.com:"`
2. The snap build of `ipsw` cannot resolve DNS on a live session.
   Used the release tar.gz binary instead.
3. `irecovery` 1.0.0 from Ubuntu 24.04 prints only CPID, so `remoteboot.sh prep`
   picked the wrong iBSS (d27). Fixed by setting MODEL=n69uap and
   PRODUCT=iPhone8,4 manually in `get_device_info()`.
4. An initramfs without busybox gives "Kernel panic: No init found". A static
   aarch64 busybox from Alpine fixed it.

Thanks to the Hoolock Linux and postmarketOS teams for the kernel and tooling.
