#!/usr/bin/env bash
# Checks the PROTECTED list and list parsing without a phone.  Run: tests/test_protected.sh
set -u
cd "$(dirname "$0")/.."
. tools/common.sh
fail=0
must_block=(
  com.android.cellbroadcastreceiver com.google.android.cellbroadcastreceiver
  com.android.cellbroadcastservice com.google.android.cellbroadcastservice
  com.android.cellbroadcastreceiver.overlay.common
  com.sec.imsservice com.sec.ims com.samsung.advp.imssettings com.qualcomm.qti.ims
  com.mediatek.ims com.google.android.ims com.huawei.ims com.shannon.imsservice com.huawei.omacp
  com.android.phone com.android.server.telecom com.android.providers.telephony com.android.stk
  com.android.systemui com.android.settings com.google.android.gms com.android.vending
  com.google.android.webview com.samsung.android.app.clockpack com.osp.app.signin
  com.xiaomi.account com.miui.securitycenter com.vivo.pem com.oplus.safecenter
  com.google.android.inputmethod.latin com.samsung.android.honeyboard com.android.managedprovisioning
)
must_allow=(
  com.miui.msa.global com.miui.analytics com.samsung.android.rubin.app com.facebook.appmanager
  com.opos.ads com.heytap.mcs com.vivo.magazine com.motorola.demo com.vilykke.lockscreen
  com.sec.android.app.sbrowser com.google.android.as com.samsung.android.app.spage
)
for p in "${must_block[@]}"; do is_protected "$p" || { echo "NOT BLOCKED: $p"; fail=1; }; done
for p in "${must_allow[@]}"; do is_protected "$p" && { echo "WRONGLY BLOCKED: $p"; fail=1; }; done

# Every uncommented entry in the starter lists must pass the protected check.
for f in examples/*/starter.txt; do
  while read -r p; do is_protected "$p" && { echo "STARTER LIST HAS PROTECTED $p ($f)"; fail=1; }; done < <(read_list "$f")
done

# Comment and whitespace handling.
tmp=$(mktemp); printf 'a.b   # note\n\n# c.d\n  e.f  \na.b\n' > "$tmp"
got=$(read_list "$tmp" | paste -sd, -); rm -f "$tmp"
[ "$got" = "a.b,e.f" ] || { echo "read_list parsed: $got"; fail=1; }

[ "$fail" = 0 ] && echo "All checks passed." || exit 1
