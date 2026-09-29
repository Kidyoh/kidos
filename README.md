# KidOS

A lightweight, keyboard-first Linux OS for old PCs, where **the whole machine has git-style history**.

- **Base:** Arch Linux
- **Desktop:** Sway (Wayland tiling), built-in bar, no Xwayland by default
- **History:** btrfs + snapper, driven by the `kidos` command. Every package install auto-snapshots
- **Lean by default:** zram swap, capped journal, solid-colour wallpaper, no firmware blobs inside VMs

## The `kidos` command

```
kidos status                 what changed since the last snapshot
kidos commit -m "msg"        snapshot the system now
kidos log                    history (your commits + automatic pacman snapshots)
kidos show HEAD              details + packages a snapshot changed
kidos diff 12 current        compare two points (files + packages)
kidos tag 12 stable          name a snapshot
kidos restore 12 /etc/foo    bring files back as they were at 12
kidos rollback stable        make the whole OS = that snapshot, reboot to apply
kidos gc                     clean up
```

Refs work like git: a number, `HEAD`, `HEAD~2`, a tag name, or `current`.
`/home` is its own subvolume, so rolling back the OS never touches your files.
To just *look* at an old state, boot it read-only from the "KidOS snapshots" GRUB menu.

## Disk layout

| Subvolume    | Mounted at               | In history? |
|--------------|--------------------------|-------------|
| `@`          | `/`                      | yes (the "repo") |
| `@snapshots` | `/.snapshots`            | it *is* the history |
| `@home`      | `/home`                  | no |
| `@log`       | `/var/log`               | no |
| `@pkg`       | `/var/cache/pacman/pkg`  | no |

## Try it (fast path, no ISO build)

1. Make a VM (VirtualBox / Hyper-V / VMware): 2 CPU, 2GB RAM, 20GB disk, NAT network. EFI on or off, both work.
2. Boot the official Arch ISO in it.
3. In the live shell:
   ```
   pacman -Sy --noconfirm git
   git clone <your KidOS repo url> kidos && cd kidos
   KIDOS_PAYLOAD=$PWD bash iso/airootfs/usr/local/bin/kidos-install
   ```
4. Reboot, remove the ISO. You land in Sway. `Super+Enter` opens a terminal, run `kidos log`.

## Build the KidOS ISO

On any Arch machine or VM:

```
sudo bash build.sh     # ISO in ./out/kidos-YYYY.MM.DD-x86_64.iso
```

Boot it and run `kidos-install`.

Unattended install (for scripts and agents):

```
KIDOS_DISK=/dev/vda KIDOS_USER=kidus KIDOS_PASS=changeme KIDOS_YES=1 kidos-install
```

## Keys

| Key | Action |
|-----|--------|
| `Super+Enter` | terminal (foot) |
| `Super+Space` | app launcher (fuzzel) |
| `Super+W` | close window |
| `Super+F` / `Super+T` | fullscreen / floating |
| `Super+H/J/K/L` | focus (Shift = move) |
| `Super+1..9` | workspaces (Shift = send window) |
| `Super+G` | machine history (`kidos log`) |
| `Super+Shift+S` | screenshot region to clipboard |
| `Super+Esc` | lock |
| `Super+Shift+E` | log out |

## Repo layout

```
build.sh                    builds the ISO (releng profile + our overlay)
iso/                        live-ISO only: installer, motd, extra packages
packages/base.txt           what gets installed on the target
system/                     files copied onto the installed system (/usr/local/bin/kidos, configs)
ROADMAP.md
```
