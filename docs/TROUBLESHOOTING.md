# Troubleshooting / פתרון תקלות

## `adb devices` shows nothing
- Use a **data** cable, try another port, pick "File transfer" in the phone's USB notification.
- Windows: install the vendor USB driver (Samsung USB Driver, Google USB Driver for Pixel).
- Xiaomi: also turn on *Install via USB* and *USB debugging (Security settings)*.

## `unauthorized`
Unlock the phone and tap **Allow** on "Allow USB debugging?". No prompt? Developer options → Revoke USB
debugging authorisations, unplug, plug back in.

## Every package fails
The firmware refuses `pm disable-user` (`disable.sh` exits 2). Check with `adb shell pm list packages -d`, not the
exit code. Don't keep retrying.
- Xiaomi HyperOS 2+: "Cannot disable system packages / miui core packages" → re-run with `ALLOW_UNINSTALL=1`
  for safe packages only. Android 17+ refuses uninstall-for-user of system apps too.
- ColorOS: "new state: default" = silently refused.
- Vivo Funtouch 12/13: `DELETE_FAILED_USER_RESTRICTED`.
- Anything: "Cannot disable a protected package" = the phone (or a work/school device policy) protects it. Leave it.
Then fall back to the toggles in `docs/settings-toggles.md` and optional Private DNS.

## "Shell cannot change component state for null to 3"
The package is already disabled. Not an error.

## Something stopped working after a batch
Run `tools/restore.sh <the packages from that batch>` (they are at the end of
`~/.cleanyourphone/<model_serial>/disabled.txt`). Without a computer: Settings → Apps → ⋮ → Show system apps →
the app → Enable. If the Enable button is grey, use `restore.sh`.

## Packages came back after a reboot
If you rebooted right after disabling, Android may not have saved yet (it writes ~10 s later). Re-run
`tools/check.sh --fix`, wait 15 s, reboot. If they come back again, the firmware re-enables them at boot: note it
in `MY-PHONE.md`.

## Packages came back after a system update
Normal. `tools/check.sh --fix`.

## Black or empty screenshot
The app on screen blocks screenshots (banking, Netflix, password fields). Check what's on screen with
`adb shell dumpsys activity activities | grep -i ResumedActivity`.

## The phone loops on boot
Rare with the protected list. Android drops into recovery after about five failed boots: there, the only fix is a
factory reset (erases data). If adb still answers during boot, run `tools/restore.sh` first. This is why
changes go in small batches with tests in between.

## Banking / payment apps won't open
Developer options are still on. `tools/finish.sh`, or Settings → System → Developer options → switch off.
