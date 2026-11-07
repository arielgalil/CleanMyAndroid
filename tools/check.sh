#!/usr/bin/env bash
# Compare the phone with what disable.sh recorded. Run it after a reboot or a
# system update: some firmware (Xiaomi, ColorOS) switches packages back on.
#   tools/check.sh         report only (exit 1 if something came back)
#   tools/check.sh --fix   disable again whatever came back (full safety checks)
set -uo pipefail
cd "$(dirname "$0")/.."
. tools/common.sh
require_device

LOG="$STATE_DIR/$(device_id)/disabled.txt"
[ -f "$LOG" ] || die "No record at $LOG."
OFF=$(ash pm list packages -d | sed 's/^package://')
ALL=$(ash pm list packages | sed 's/^package://')
back=()
while read -r _ act p; do
  if [ "$act" = "uninstalled" ]; then grep -qx "$p" <<<"$ALL" && back+=("$p")
  else grep -qx "$p" <<<"$OFF" || back+=("$p"); fi
done < "$LOG"

if [ "${#back[@]}" -eq 0 ]; then echo "Everything in the record is still off."; exit 0; fi
echo "Back on since disable.sh ran:"; printf '  %s\n' "${back[@]}"
if [ "${1:-}" = "--fix" ]; then
  tmp=$(mktemp); printf '%s\n' "${back[@]}" > "$tmp"
  YES=1 tools/disable.sh "$tmp"; rm -f "$tmp"
else
  exit 1
fi
