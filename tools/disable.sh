#!/usr/bin/env bash
# Disable the packages in a list file, one at a time, with safety checks.
# Default action: `pm disable-user --user 0`. Nothing is uninstalled.
#
# Usage:  tools/disable.sh my-list.txt               (asks once before starting)
#         DRY_RUN=1 tools/disable.sh my-list.txt     (shows what would happen)
#         YES=1 tools/disable.sh my-list.txt         (no question; for the assistant)
#         ALLOW_UNINSTALL=1 tools/disable.sh list    (if the phone refuses to disable a
#             package, remove it for user 0 instead. Still reversible with
#             restore.sh (cmd package install-existing). Needed on Xiaomi HyperOS 2+.
#             Refused by Android 17+ for system apps, so it is skipped there.)
#
# Each change is appended to ~/.cleanyourphone/<model_serial>/disabled.txt as
#   <time> <disabled|uninstalled> <package>
# restore.sh reads that record to undo everything.
set -uo pipefail
cd "$(dirname "$0")/.."
. tools/common.sh

LIST="${1:-}"
[ -n "$LIST" ] && [ -f "$LIST" ] || die "Usage: tools/disable.sh <list.txt>"
require_device

ID=$(device_id)
DIR="$STATE_DIR/$ID"
mkdir -p "$DIR"
LOG="$DIR/disabled.txt"
[ -e "$DIR/latest-backup" ] || die "No backup for this phone yet. Run tools/backup.sh first."
SDK=$(ash getprop ro.build.version.sdk); SDK=${SDK:-0}

mapfile -t PKGS < <(read_list "$LIST")
[ "${#PKGS[@]}" -gt 0 ] || die "List is empty."
[ "${#PKGS[@]}" -le 10 ] || warn "${#PKGS[@]} packages in one list. Batches of 5-10 are safer: one batch can take something load-bearing with it."

HOME_PKG=$(current_home)
WEBVIEW=$(webview_provider)
mapfile -t KEEP_ROLES < <(for r in android.app.role.SMS android.app.role.DIALER android.app.role.HOME; do role_holders "$r"; done)
[ -n "$HOME_PKG" ] || warn "Could not read the current Home app; the Home guard is not active."
INSTALLED=$(ash pm list packages | sed 's/^package://')
DISABLED_NOW=$(ash pm list packages -d | sed 's/^package://')

PLAN=()
for p in "${PKGS[@]}"; do
  if is_protected "$p"; then echo "SKIP (protected: the phone needs it)  $p"; continue; fi
  if [ "$p" = "$HOME_PKG" ]; then echo "SKIP (current Home app; set another launcher first)  $p"; continue; fi
  if [ -n "$WEBVIEW" ] && [ "$p" = "$WEBVIEW" ]; then echo "SKIP (current WebView provider)  $p"; continue; fi
  if printf '%s\n' "${KEEP_ROLES[@]}" | grep -qx "$p"; then echo "SKIP (default SMS/Phone/Home app)  $p"; continue; fi
  if ! grep -qx "$p" <<<"$INSTALLED"; then echo "SKIP (not installed)  $p"; continue; fi
  if grep -qx "$p" <<<"$DISABLED_NOW"; then echo "SKIP (already disabled)  $p"; continue; fi
  PLAN+=("$p")
done

[ "${#PLAN[@]}" -gt 0 ] || { echo "Nothing to do."; exit 0; }
echo; echo "Will disable ${#PLAN[@]} package(s):"; printf '  %s\n' "${PLAN[@]}"
[ "${DRY_RUN:-0}" = 1 ] && { echo "(dry run, nothing changed)"; exit 0; }
if [ "${YES:-0}" != 1 ]; then
  read -r -p "Continue? [y/N] " a; [[ "$a" =~ ^[yY] ]] || { echo "Cancelled."; exit 0; }
fi

is_disabled() { ash pm list packages -d | sed 's/^package://' | grep -qx "$1"; }
is_installed() { ash pm list packages | sed 's/^package://' | grep -qx "$1"; }

ok=0; fail=0; refused=0
for p in "${PLAN[@]}"; do
  # One pm call per adb shell: chained commands can stop silently.
  out=$(ash pm disable-user --user 0 "$p" 2>&1)
  # Trust the package state, not the exit code: ColorOS answers "new state: default"
  # when it silently refuses.
  if is_disabled "$p"; then
    echo "$(date +%F_%T) disabled $p" >> "$LOG"; echo "OK    $p"; ok=$((ok+1)); continue
  fi
  if grep -q "protected package" <<<"$out"; then
    echo "LOCKED $p  (the phone marks it protected; leave it)"; refused=$((refused+1)); continue
  fi
  if [ "${ALLOW_UNINSTALL:-0}" = 1 ] && [ "$SDK" -lt 37 ]; then
    out2=$(ash pm uninstall -k --user 0 "$p" 2>&1)
    if ! is_installed "$p"; then
      echo "$(date +%F_%T) uninstalled $p" >> "$LOG"; echo "OK*   $p  (removed for user 0; restore.sh brings it back)"; ok=$((ok+1)); continue
    fi
    out="$out / $out2"
  fi
  echo "FAIL  $p  ($(tr '\n' ' ' <<<"$out"))"; fail=$((fail+1))
done

echo; echo "Done: $ok changed, $fail failed, $refused locked by the phone. Record: $LOG"
if [ "$ok" -eq 0 ] && [ $((fail+refused)) -gt 0 ]; then
  echo "Nothing could be changed. This firmware blocks disabling (see docs/TROUBLESHOOTING.md). Do not keep retrying."
  exit 2
fi
echo "Android saves package state ~10s after a change. Wait 15s (or: adb shell sync) before any reboot."
echo "Now test: a phone call, an SMS, the lock screen, notifications."
