#!/usr/bin/env bash
# CleanYourPhone - phone mode. A guided menu you run inside Termux on the phone you are cleaning.
# Same safety checks as the Claude Code flow: backup first, protected list, small batches, a test after each.
#
#   bash phone-mode/menu.sh
#
# English on purpose: Termux does not render right-to-left text correctly, as far as I know. The Hebrew
# guide is in phone-mode/README.md.
set -uo pipefail
cd "$(dirname "$0")/.."
. tools/common.sh

BATCH="${BATCH:-8}"

ask() { local a; read -r -p "$1 [y/N] " a; [[ "$a" =~ ^[yY] ]]; }

brand_dir() {
  local m; m=$(ash getprop ro.product.manufacturer | tr 'A-Z' 'a-z')
  local b; b=$(ash getprop ro.product.brand | tr 'A-Z' 'a-z')
  case "$m $b" in
    *samsung*) echo samsung;;
    *xiaomi*|*redmi*|*poco*) echo xiaomi;;
    *google*) echo pixel;;
    *oneplus*|*oppo*|*realme*) echo oneplus-oppo-realme;;
    *motorola*|*lenovo*) echo motorola;;
    *nothing*) echo nothing;;
    *vivo*|*iqoo*) echo vivo-iqoo;;
    *) echo "";;
  esac
}

ensure_wake() { command -v termux-wake-lock >/dev/null 2>&1 && termux-wake-lock 2>/dev/null; }

do_backup() { require_device; tools/backup.sh; }

do_debloat() {
  require_device
  local d; d=$(brand_dir)
  if [ -z "$d" ]; then
    echo "No starter list for this brand ($(ash getprop ro.product.manufacturer)). Use Claude Code on a computer instead,"
    echo "or put your own list in lists/mine.txt and run: YES=1 tools/disable.sh lists/mine.txt"
    return
  fi
  echo "Brand list: examples/$d/starter.txt"
  echo "Only the uncommented (safe candidate) packages are used. Lines starting with # stay on."
  [ -e "$STATE_DIR/$(device_id)/latest-backup" ] || { echo "No backup yet - making one first."; tools/backup.sh || return; }

  local installed disabled_now cand=() p
  installed=$(ash pm list packages | sed 's/^package://')
  disabled_now=$(ash pm list packages -d | sed 's/^package://')
  while read -r p; do
    is_protected "$p" && continue
    grep -qx "$p" <<<"$installed" || continue
    grep -qx "$p" <<<"$disabled_now" && continue
    cand+=("$p")
  done < <(read_list "examples/$d/starter.txt")

  if [ "${#cand[@]}" -eq 0 ]; then echo "Nothing left to disable from this list."; return; fi
  echo; echo "Candidates found on this phone:"
  local i=1; for p in "${cand[@]}"; do printf '  %2d  %s\n' "$i" "$p"; i=$((i+1)); done
  echo; echo "Each package is one app or service. See docs/brands.md for what they are."
  read -r -p "Numbers to KEEP ON, separated by spaces (Enter = disable all listed): " skip
  local keep=() n
  for i in "${!cand[@]}"; do
    n=$((i+1)); [[ " $skip " == *" $n "* ]] && continue; keep+=("${cand[$i]}")
  done
  [ "${#keep[@]}" -gt 0 ] || { echo "Nothing selected."; return; }

  ensure_wake
  mkdir -p lists
  local total=${#keep[@]} start=0 bn=1
  while [ "$start" -lt "$total" ]; do
    local chunk=("${keep[@]:$start:$BATCH}")
    printf '%s\n' "${chunk[@]}" > "lists/batch-$bn.txt"
    echo; echo "== Batch $bn: ${#chunk[@]} package(s) =="; printf '  %s\n' "${chunk[@]}"
    ask "Disable this batch?" || { echo "Skipped batch $bn."; start=$((start+BATCH)); bn=$((bn+1)); continue; }
    YES=1 tools/disable.sh "lists/batch-$bn.txt"
    echo
    echo "TEST NOW (switch to the Phone app and back): 1) the lock screen opens, 2) a call connects,"
    echo "3) an SMS or WhatsApp notification arrives, 4) the home screen and Settings open."
    if ask "Everything still works?"; then
      echo "Batch $bn kept."
    else
      echo "Restoring batch $bn..."; tools/restore.sh "${chunk[@]}"
      echo "Restored. Stop here and check docs/TROUBLESHOOTING.md before trying more."; return
    fi
    start=$((start+BATCH)); bn=$((bn+1))
  done
  echo; echo "Done. Wait 15 seconds before rebooting so Android saves the change."
  echo "After a reboot or system update, use menu item 4 to see what came back."
  echo "Next: the no-computer toggles in docs/settings-toggles.md (Hebrew)."
}

do_restore() {
  require_device
  echo "1) Undo everything recorded   2) Undo specific packages   3) Also restore Private DNS"
  read -r -p "Choose: " c
  case "$c" in
    1) tools/restore.sh;;
    2) read -r -p "Package names, separated by spaces: " pk; tools/restore.sh $pk;;
    3) tools/restore.sh --dns;;
  esac
}

while true; do
  echo
  echo "===== CleanYourPhone - phone mode ====="
  echo " 1) Connect to this phone (Wireless debugging)"
  echo " 2) Back up the current state"
  echo " 3) Guided debloat for my brand"
  echo " 4) Check what came back (after update or reboot)"
  echo " 5) Restore apps"
  echo " 6) Finish: turn debugging off (banking apps work again)"
  echo " q) Quit"
  read -r -p "> " c
  case "$c" in
    1) tools/connect-local.sh;;
    2) do_backup;;
    3) do_debloat;;
    4) require_device; tools/check.sh --fix;;
    5) do_restore;;
    6) require_device; tools/finish.sh;;
    q|Q) exit 0;;
    *) echo "Choose 1-6 or q.";;
  esac
done
