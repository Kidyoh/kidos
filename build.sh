#!/usr/bin/env bash
# build.sh — build the KidOS live/installer ISO.
# Run as root on an Arch Linux machine or VM (needs the `archiso` package).
#
#   sudo ./build.sh            -> ISO lands in ./out/
#
# How it works: we start from Arch's official "releng" archiso profile (so boot
# configs stay current with upstream) and overlay only what KidOS changes.
set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
WORK=${WORK:-/tmp/kidos-build}
OUT=${OUT:-$HERE/out}

[[ $EUID -eq 0 ]] || { echo "build.sh: run as root (sudo ./build.sh)" >&2; exit 1; }
command -v pacman >/dev/null || { echo "build.sh: must run on Arch Linux" >&2; exit 1; }
command -v mkarchiso >/dev/null || pacman -S --needed --noconfirm archiso

rm -rf "$WORK"
mkdir -p "$WORK" "$OUT"
cp -r /usr/share/archiso/configs/releng "$WORK/profile"
P=$WORK/profile

# 1. Extra packages on the live ISO (the installed system's list is packages/base.txt)
grep -Ev '^\s*(#|$)' "$HERE/iso/packages.extra" >> "$P/packages.x86_64"
LC_ALL=C sort -u -o "$P/packages.x86_64" "$P/packages.x86_64"

# 2. Live-environment overlay (installer, motd)
cp -a "$HERE/iso/airootfs/." "$P/airootfs/"

# 3. Payload the installer copies onto the target disk
mkdir -p "$P/airootfs/usr/share/kidos"
cp -a "$HERE/system" "$HERE/packages" "$P/airootfs/usr/share/kidos/"
git -C "$HERE" remote get-url origin > "$P/airootfs/usr/share/kidos/repo" 2>/dev/null || true
git -C "$HERE" rev-parse HEAD > "$P/airootfs/usr/share/kidos/version" 2>/dev/null || true

# 4. Branding + executable bits (mkarchiso resets file modes)
sed -i \
  -e 's/^iso_name=.*/iso_name="kidos"/' \
  -e 's/ARCH_/KIDOS_/' \
  -e 's/^iso_publisher=.*/iso_publisher="KidOS <https:\/\/kidus-yohannes.engineer>"/' \
  -e 's/^iso_application=.*/iso_application="KidOS Live\/Install"/' \
  "$P/profiledef.sh"
sed -i '/^file_permissions=(/a\  ["/usr/local/bin/kidos-install"]="0:0:755"' "$P/profiledef.sh"
while IFS= read -r f; do
  rel=${f#"$HERE/system"}
  sed -i "/^file_permissions=(/a\\  [\"/usr/share/kidos/system${rel}\"]=\"0:0:755\"" "$P/profiledef.sh"
done < <(find "$HERE/system/usr/local/bin" -type f)

mkarchiso -v -w "$WORK/work" -o "$OUT" "$P"
echo
echo "Done. ISO: $(ls -t "$OUT"/kidos-*.iso | head -1)"
