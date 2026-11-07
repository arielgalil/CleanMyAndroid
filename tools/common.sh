#!/usr/bin/env bash
# Shared helpers for CleanYourPhone tools. Sourced, not run.
# ADB_SERIAL=<serial>  picks a device when more than one is connected (adb devices -l).

ADB=(adb)
if [ -n "${ADB_SERIAL:-}" ]; then ADB=(adb -s "$ADB_SERIAL"); fi
STATE_DIR="${CYP_STATE_DIR:-$HOME/.cleanyourphone}"

die() { echo "ERROR: $*" >&2; exit 1; }
warn() { echo "WARN: $*" >&2; }

ash() { "${ADB[@]}" shell "$@" | tr -d '\r'; }

require_device() {
  command -v adb >/dev/null 2>&1 || die "adb not found. Install Android platform-tools first (see README)."
  local n
  n=$(adb devices | tr -d '\r' | awk 'NR>1 && $2=="device"' | wc -l)
  if [ -z "${ADB_SERIAL:-}" ] && [ "$n" -gt 1 ]; then
    die "More than one device connected. Set ADB_SERIAL (see: adb devices -l)."
  fi
  local st
  st=$("${ADB[@]}" get-state 2>/dev/null | tr -d '\r')
  [ "$st" = "device" ] || die "No authorised phone. Unlock it and tap Allow on the 'Allow USB debugging?' prompt."
}

device_id() {
  local s m
  s=$("${ADB[@]}" get-serialno 2>/dev/null | tr -d '\r')
  # Wireless/local connections (phone mode) show host:port, and the port changes every time.
  # Use Android's own stable id then, so the record of disabled apps is found again.
  case "$s" in *:*) s=$(ash settings get secure android_id);; esac
  m=$(ash getprop ro.product.model | tr ' /' '__')
  echo "${m}_${s}"
}

# Read a list file: one package per line, '#' starts a comment, blank lines ignored.
read_list() {
  sed -e 's/#.*//' -e 's/[[:space:]]//g' "$1" | awk 'NF' | awk '!seen[$0]++'
}

# ---------------------------------------------------------------------------
# Packages that must never be disabled on a phone. Exact names or prefix*.
# Disabling any of these can stop calls, SMS, emergency alerts, the lock
# screen, app installs or booting. Keep this list conservative.
# ---------------------------------------------------------------------------
PROTECTED=(
  # Android core
  "android" "com.android.systemui" "com.android.settings" "com.android.shell"
  "com.android.phone" "com.android.server.telecom" "com.android.providers.*"
  "com.android.permissioncontroller" "com.google.android.permissioncontroller"
  "com.android.packageinstaller" "com.google.android.packageinstaller"
  "com.android.ext.services" "com.google.android.ext.services"
  "com.android.ext.shared" "com.google.android.ext.shared"
  "android.ext.services" "android.ext.shared"
  "com.android.modulemetadata" "com.google.android.modulemetadata"
  "com.google.android.overlay.modules*" "com.android.networkstack*" "com.google.android.networkstack*"
  "com.android.wifi.*" "com.google.android.wifi.*" "com.android.tethering*" "com.google.android.tethering*"
  "com.android.connectivity.*" "com.google.android.connectivity.*"
  "com.android.adservices.api" "com.google.android.adservices.api"
  "com.android.keychain" "com.android.location.fused" "com.android.externalstorage"
  "com.android.mtp" "com.android.documentsui" "com.google.android.documentsui"
  "com.android.inputdevices" "com.android.localtransport" "com.android.dynsystem"
  "com.android.media*" "com.google.android.media*" "com.android.webview" "com.google.android.webview"
  "com.android.bluetooth" "com.google.android.bluetooth" "com.android.nfc" "com.android.se"
  "com.android.deskclock" "com.google.android.deskclock"
  # Calls, SIM, VoLTE (Israel shut down 2G/3G: without IMS there are no calls)
  "com.android.ims*" "com.google.android.ims*" "com.android.carrierconfig" "com.google.android.carrierconfig"
  "com.android.carrierdefaultapp" "com.android.stk" "com.android.simappdialog" "com.android.mms.service"
  "com.android.telephony*" "com.google.android.telephony*" "com.android.phone.*"
  "com.qualcomm.qti.ims" "com.qualcomm.qti.telephonyservice" "com.qualcomm.qti.uceShimService"
  "com.sec.imsservice" "com.sec.ims" "com.shannon.imsservice" "com.mediatek.ims"
  "com.sec.phone" "com.samsung.android.app.telephonyui" "com.sec.android.app.servicemodeapp"
  "com.android.euicc" "com.google.android.euicc" "com.samsung.euicc"
  "com.samsung.advp.imssettings" "com.huawei.ims" "com.shannon.*" "*omacp*"
  # Emergency alerts (Pikud HaOref "personal message" = cell broadcast) and emergency services
  "*cellbroadcast*"
  "com.android.emergency" "com.google.android.apps.safetyhub" "com.samsung.android.emergency*"
  # Lock screen and OEM accounts (removing an account package can lock you out)
  "com.samsung.android.app.clockpack" "com.samsung.android.dynamiclock" "com.osp.app.signin"
  "com.xiaomi.account" "com.bbk.account" "com.android.bbk.lockscreen3" "com.hihonor.id"
  # Work profile / Secure Folder: disabling these crash-loops One UI
  "com.android.managedprovisioning" "com.samsung.android.knox.containercore"
  # Vendor security/power managers reported to break notifications or SIM handling
  "com.vivo.pem" "com.iqoo.secure" "com.hihonor.phoneservices"
  "com.huawei.systemmanager" "com.huawei.android.hwouc" "com.huawei.android.dsdscardmanager"
  # Google basics
  "com.google.android.gms" "com.google.android.gsf" "com.android.vending"
  "com.google.android.gms.*"
  # Keyboards
  "com.android.inputmethod.*" "com.google.android.inputmethod.*" "com.samsung.android.honeyboard"
  "com.sohu.inputmethod.sogou.xiaomi" "com.touchtype.swiftkey"
  # Lock screen, biometrics, security
  "com.android.biometrics*" "com.samsung.android.biometrics*" "com.samsung.android.bio.face.service"
  "com.samsung.android.knox.*" "com.samsung.knox.*" "com.sec.android.app.SecSetupWizard"
  "com.google.android.setupwizard" "com.android.provision"
  "com.miui.securitycenter" "com.lbe.security.miui" "com.miui.guardprovider" "com.xiaomi.finddevice"
  "com.miui.securitycore" "com.miui.powerkeeper" "com.android.updater"
  # Vendor framework
  "com.samsung.android.providers.*" "com.sec.android.provider.*" "com.miui.core" "com.miui.rom"
  "com.miui.system" "com.xiaomi.xmsf" "com.qualcomm.location" "com.qualcomm.qti.services.*"
  "com.coloros.safecenter" "com.oplus.*" "com.oppo.*" "com.heytap.speechassist.*"
)

is_protected() {
  local p="$1" pat
  for pat in "${PROTECTED[@]}"; do
    # shellcheck disable=SC2053
    if [[ "$p" == $pat ]]; then return 0; fi
  done
  return 1
}

# Current Home app, default SMS and dialer. Empty when the phone can't tell.
current_home() {
  ash cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME 2>/dev/null \
    | grep / | tail -n1 | cut -d/ -f1
}
webview_provider() {
  ash dumpsys webviewupdate 2>/dev/null | sed -n 's/.*Current WebView package (name, version): (\([^,]*\),.*/\1/p' | head -n1
}
role_holders() {  # $1 = role name, Android 10+
  ash cmd role get-role-holders --user 0 "$1" 2>/dev/null | tr ';' '\n' | awk 'NF'
}
