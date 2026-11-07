#!/usr/bin/env bash
# Close debugging at the end of the session.
# Switches off Wireless debugging, then USB debugging, then hides Developer
# options. After this, adb can no longer reach the phone (that is the point).
# Banking and payment apps that refuse to run with Developer options on will
# work again.
#
# Revoke the computer's authorisation yourself on the phone if you want:
#   Settings > Developer options > Revoke USB debugging authorisations
# (do it BEFORE running this script, while the menu is still visible).
set -uo pipefail
cd "$(dirname "$0")/.."
. tools/common.sh
require_device

echo "This turns off debugging. The assistant loses access to the phone right after."
if [ "${YES:-0}" != 1 ]; then
  read -r -p "Continue? [y/N] " a; [[ "$a" =~ ^[yY] ]] || exit 0
fi
ash sync
ash settings put global adb_wifi_enabled 0 >/dev/null 2>&1
ash settings put global development_settings_enabled 0
ash settings put global adb_enabled 0 >/dev/null 2>&1   # connection drops here
sleep 2
if [ "$("${ADB[@]}" get-state 2>/dev/null | tr -d '\r')" = "device" ]; then
  echo "A device still answers adb. Turn off USB debugging by hand: Settings > Developer options."
  exit 1
fi
echo "Debugging is off. Check on the phone: Settings > System (or Additional settings) should no longer show Developer options."
