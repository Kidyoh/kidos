# KidOS roadmap

## v0.1 — Foundation (this)
- [x] Arch base, archiso build on top of upstream releng
- [x] Installer: btrfs subvolume layout, GRUB (UEFI + BIOS), unattended mode
- [x] `kidos` CLI: status / commit / log / show / diff / tag / restore / rollback / gc
- [x] Auto-snapshots on every pacman transaction, bootable snapshots in GRUB
- [x] Sway desktop, lean defaults (zram, no Xwayland, tiny status bar)
- [x] First boot tested in VirtualBox (UEFI): Sway desktop at ~416MB used / 2GB
- [x] Own pacman snapshot hooks (dropped snap-pac + Python)

## v0.2 — Daily driver (this)
- [x] `kidos ask`: AI with shell tool, per-command approval, read-only auto-run, snapshot per session
- [x] `kidos update`: self-update from GitHub + full system upgrade as one snapshot pair
- [x] Branding: os-release, fastfetch logo, GRUB colours, console banner, first-login welcome
- [x] KidOS menu: Wi-Fi, Bluetooth, sound, clipboard history, night light, app installer, power
- [ ] Test all of the above on the VM
- [ ] Test BIOS (non-EFI) install

## v0.3 — Agent-native, deeper
- [ ] Every `kidos` command gets `--json` so agents can drive the OS
- [ ] System tools exposed over MCP
- [ ] Optional local model (llama.cpp) for offline `kidos ask`

## v0.4 — Declarative layer
- [ ] `kidos.toml` describing packages + services; `kidos apply` makes the machine match it
- [ ] Commits record which config produced them

## v0.5 — Memory-first + low-bandwidth
- [ ] Idle RAM budget enforced in CI (target: < 300MB with Sway)
- [ ] LAN package cache sharing between KidOS machines
- [ ] Offline install from the ISO's own package cache

## Branding
- [ ] Full GRUB theme, boot splash, wallpaper option
