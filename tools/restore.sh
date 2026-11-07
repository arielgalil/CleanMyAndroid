#!/usr/bin/env bash
# Undo CleanYourPhone: bring back everything disable.sh changed, and (with --dns)
# put Private DNS back the way the backup found it.
#
# Usage:  tools/restore.sh              undo every change in the record
#         tools/restore.sh com.foo.bar  bring back just these packages
#         tools/restore.sh --dns        also restore Private DNS from the backup
#
# Without a computer: Settings > Apps > (show system apps) > the app > Enable.
# A factory reset also brings every system app back.
set -uo pipefail
cd "$(dirname "$0")/.."
. tools/common.sh
require_device

DIR="$STATE_DIR/$(device_id)"
LOG="$DIR/disabled.txt"
DNS=0; ONLY=()
for a in "$@"; do
  if [ "$a" = "--dns" ]; then DNS=1; else ONLY+=("$a"); fi
done

if [ "${#ONLY[@]}" -gt 0 ]; then
  PKGS=("${ONLY[@]}")
elif [ -f "$LOG" ]; then
  mapfile -t PKGS < <(awk '{print $NF}' "$LOG" | awk '!seen[$0]++')
else
  PKGS=()
  [ "$DNS" = 1 ] || die "No record at $LOG. These tools changed nothing on this phone."
fi

for p in "${PKGS[@]}"; do
  # Covers both actions: install-existing brings back an app removed for user 0
  # (harmless if it is still installed), pm enable switches it back on.
  ash cmd package install-existing --user 0 "$p" >/dev/null 2>&1
  out=$(ash pm enable --user 0 "$p" 2>&1)
  if ash pm list packages -e | sed 's/^package://' | grep -qx "$p"; then echo "OK    $p"
  else echo "FAIL  $p  ($out)"; fi
done

if [ "$DNS" = 1 ]; then
  B="$DIR/latest-backup/defaults.txt"
  [ -f "$B" ] || die "No backup defaults at $B"
  mode=$(sed -n 's/^private_dns_mode=//p' "$B"); spec=$(sed -n 's/^private_dns_specifier=//p' "$B")
  if [ -z "$mode" ] || [ "$mode" = "null" ]; then ash settings delete global private_dns_mode >/dev/null
  else ash settings put global private_dns_mode "$mode"; fi
  if [ -z "$spec" ] || [ "$spec" = "null" ]; then ash settings delete global private_dns_specifier >/dev/null
  else ash settings put global private_dns_specifier "$spec"; fi
  echo "Private DNS restored to: ${mode:-default}"
fi

# Keep the record honest: keep only entries that are still off or removed.
if [ -f "$LOG" ]; then
  OFF=$(ash pm list packages -d | sed 's/^package://')
  ALL=$(ash pm list packages | sed 's/^package://')
  tmp=$(mktemp)
  while read -r t act p; do
    if grep -qx "$p" <<<"$OFF" || ! grep -qx "$p" <<<"$ALL"; then echo "$t $act $p"; fi
  done < "$LOG" > "$tmp"
  mv "$tmp" "$LOG"
fi
echo "Done. Wait 15s before rebooting so Android saves the change."
