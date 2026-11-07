#!/usr/bin/env bash
# Connect adb on THIS phone to itself, through Wireless debugging (Android 11+).
# Run inside Termux:  pkg install android-tools
#
# The phone must be on Wi-Fi: Android switches Wireless debugging off when Wi-Fi drops,
# and a new port is used every time it starts. Never use `adb tcpip`.
set -uo pipefail
command -v adb >/dev/null 2>&1 || { echo "adb not found. In Termux run:  pkg install android-tools"; exit 1; }

connected() { adb devices | tr -d '\r' | awk 'NR>1 && $2=="device"' | grep -q .; }

if connected; then echo "Already connected:"; adb devices -l; exit 0; fi

cat <<'EOF'
On the phone, open: Settings > Developer options > Wireless debugging (turn it on).
Then use split-screen or the pop-up window so Termux and Settings are both visible
(pairing codes expire when the dialog closes).

Step 1 of 2 - pairing (once per session):
  Wireless debugging > "Pair device with pairing code".
  The dialog shows "IP address & Port" (for example 192.168.1.20:37215) and a 6-digit code.
EOF
read -r -p "Pairing port (the number after the colon): " PP
read -r -p "6-digit pairing code: " CODE
adb pair "localhost:$PP" "$CODE" || { echo "Pairing failed. Check the port and code, and keep the dialog open."; exit 1; }

cat <<'EOF'

Step 2 of 2 - connecting:
  Close the pairing dialog. On the Wireless debugging screen itself, look at
  "IP address & Port". The port there is DIFFERENT from the pairing port.
EOF
read -r -p "Connection port: " CP
adb connect "localhost:$CP"
sleep 1
if connected; then
  echo "Connected."; adb devices -l
  echo "If a prompt 'Allow USB debugging?' appears, tick 'Always allow' and tap Allow."
else
  echo "Not connected. Wireless debugging must stay on, and the phone must be on Wi-Fi."; exit 1
fi
