#!/usr/bin/env bash
# Take a screenshot from the phone and save it on the computer.
#   tools/shot.sh shots/01-home.png
# A black or empty image usually means the app on screen blocks screenshots
# (banking apps, Netflix, password fields). That is the app, not damage:
# check what is on screen with
#   adb shell dumpsys activity activities | grep -i ResumedActivity
set -euo pipefail
cd "$(dirname "$0")/.."
. tools/common.sh
require_device
OUT="${1:-shots/$(date +%H%M%S).png}"
mkdir -p "$(dirname "$OUT")"
"${ADB[@]}" exec-out screencap -p > "$OUT"
if [ ! -s "$OUT" ]; then
  echo "Empty screenshot: the app on screen blocks capture." >&2; exit 1
fi
echo "$OUT"
