<img width="2160" height="3840" alt="B58ABF9A-F1E6-4738-995B-7DA36D37CBFD" src="https://github.com/user-attachments/assets/2479032c-d347-4127-8c97-2f321b1776fc" />
<img width="2160" height="3840" alt="A4ADD063-37CC-4A1F-8533-E8BC5F008C2E" src="https://github.com/user-attachments/assets/444e40a5-d29b-46b3-9895-46e2bbf3125f" />
# Iphone-se-linux
Booting Linux 7.0.4 (postmarketOS kernel) on iPhone SE 1st gen (A9) via checkm8, remote_boot and m1n1

# Linux on iPhone SE 1st gen (A9)

Booting the postmarketOS 16k kernel (7.0.4) to userspace on an iPhone SE 1st gen
(iPhone8,4, CPID 0x8000, board n69uap), tethered via checkm8.
<img width="2160" height="3840" alt="EDEE775F-BBD8-4452-8E66-D7192F5C3725" src="https://github.com/user-attachments/assets/bb930dd0-29ce-4d95-add6-fd20a5c33441" />

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
<img width="2160" height="3840" alt="815FFF1A-F6E6-43FA-9692-3C2731F3187B" src="https://github.com/user-attachments/assets/132f9b6f-bd31-4df1-abec-63a12d954b3a" /> 
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
