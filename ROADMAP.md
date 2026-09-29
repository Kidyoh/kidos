# KidOS roadmap

## v0.1 — Foundation (this)
- [x] Arch base, archiso build on top of upstream releng
- [x] Installer: btrfs subvolume layout, GRUB (UEFI + BIOS), unattended mode
- [x] `kidos` CLI: status / commit / log / show / diff / tag / restore / rollback / gc
- [x] Auto-snapshots on every pacman transaction, bootable snapshots in GRUB
- [x] Sway desktop, lean defaults (zram, no Xwayland, tiny status bar)
- [ ] First boot tested in VM (UEFI + BIOS), measure idle RAM

## v0.2 — Agent-native
- [ ] `kidos ask "..."` — local or API model with tool access to the system
- [ ] Every `kidos` command gets `--json` so agents can drive the OS
- [ ] Agent actions auto-commit, so anything an agent does can be rolled back
- [ ] System tools exposed over MCP

## v0.3 — Declarative layer
- [ ] `kidos.toml` describing packages + services; `kidos apply` makes the machine match it
- [ ] Commits record which config produced them

## v0.4 — Memory-first + low-bandwidth
- [ ] Idle RAM budget enforced in CI (target: < 300MB with Sway)
- [ ] LAN package cache sharing between KidOS machines
- [ ] Offline install from the ISO's own package cache

## Branding
- [ ] Own os-release / fastfetch logo, GRUB theme, boot splash
