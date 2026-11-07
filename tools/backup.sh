#!/usr/bin/env bash
# Save the phone's state before anything changes.
# Usage: tools/backup.sh            -> ~/.cleanyourphone/<model_serial>/backup-<time>/
set -euo pipefail
cd "$(dirname "$0")/.."
. tools/common.sh
require_device

ID=$(device_id)
OUT="$STATE_DIR/$ID/backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$OUT"

echo "Backing up to $OUT"
ash pm list packages -f            > "$OUT/packages-all.txt"
ash pm list packages -d            > "$OUT/packages-disabled.txt"
ash pm list packages -s            > "$OUT/packages-system.txt"
ash pm list packages -3            > "$OUT/packages-user.txt"
ash getprop                        > "$OUT/getprop.txt"
ash settings list global           > "$OUT/settings-global.txt"
ash settings list secure           > "$OUT/settings-secure.txt"
ash settings list system           > "$OUT/settings-system.txt"
{ echo "home=$(current_home)"
  echo "webview=$(webview_provider)"
  for r in android.app.role.SMS android.app.role.DIALER android.app.role.HOME android.app.role.BROWSER android.app.role.ASSISTANT; do
    echo "$r=$(role_holders "$r" | paste -sd, -)"
  done
  echo "private_dns_mode=$(ash settings get global private_dns_mode)"
  echo "private_dns_specifier=$(ash settings get global private_dns_specifier)"
} > "$OUT/defaults.txt"

# Mark the newest backup so restore.sh can find it.
ln -sfn "$OUT" "$STATE_DIR/$ID/latest-backup"
echo "Done. $(wc -l < "$OUT/packages-all.txt") packages recorded, $(wc -l < "$OUT/packages-disabled.txt") already disabled."
