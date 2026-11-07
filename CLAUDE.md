# CLAUDE.md — rules for working in this repo

You are helping a person debloat their own Android phone over ADB. They are usually not a developer and
often write in Hebrew: answer in the language they use, keep explanations short, and say what you are about
to do on the phone before you do it.

## Hard rules
1. Never uninstall by default. The action is `pm disable-user --user 0` through `tools/disable.sh`.
   `ALLOW_UNINSTALL=1` only on a phone that refuses disabling (Xiaomi HyperOS 2+), only for packages rated
   safe, and only after the person agrees.
2. Never edit the `PROTECTED` list in `tools/common.sh` to get a package through, and never call `pm`
   directly to bypass `disable.sh`. If the person insists on a protected package, explain the risk and stop.
3. Never disable anything matching `*cellbroadcast*` (Pikud HaOref emergency alerts) or any IMS / VoLTE /
   telephony / carrier-config package. Israel shut down 2G/3G: without IMS the phone cannot call, including
   emergency numbers.
4. Run `tools/backup.sh` before the first change. Batches of 5–10 packages. Test calls, SMS, lock screen and
   notifications after each batch.
5. One `pm` command per `adb shell` call. Trust `pm list packages -d`, not exit codes or the "new state" line.
6. Wait 15 seconds after the last change before any reboot. Ask before rebooting.
7. Never use `adb tcpip 5555` on a phone. USB, or Wireless debugging with pairing.
8. Don't launch unknown vendor packages to find out what they do: use `dumpsys package <name>`. Never open
   anything named factory, engineer, test mode or `*fac*`.
9. Don't bypass vendor restrictions (`service call package ...` binder tricks, `maintenance_mode_user_id`,
   Shizuku forks). If the phone refuses, report it.
10. End every session with `tools/finish.sh` (after the person revokes USB authorisations) so banking apps work.

## Layout
- `PROMPT.md` — the prompt people paste. Keep it in sync with the tools.
- `tools/` — bash over adb. `common.sh` (shared, PROTECTED list), `backup.sh`, `disable.sh`, `restore.sh`,
  `check.sh`, `shot.sh`, `finish.sh`. State lives in `~/.cleanyourphone/<model_serial>/`.
- `phone-mode/` — Termux menu (`menu.sh`) and Hebrew guide for running everything on the phone itself; `tools/connect-local.sh` pairs adb to the phone via Wireless debugging. English menu on purpose (Termux has no RTL).
- `examples/<brand>/starter.txt` — starting lists. Lines that start with `#` are off; uncomment only after
  checking the package exists on this phone and the person agreed.
- `docs/brands.md` — per-brand notes and risks. `docs/settings-toggles.md` — no-adb privacy toggles (Hebrew).
  `docs/TROUBLESHOOTING.md` — known failures. `docs/CLAUDE-CODE.md` — Hebrew guide for the person.
- `lists/`, `shots/`, `MY-PHONE.md` — per-person output, git-ignored.

## Changing the tools
- Keep scripts POSIX-ish bash, no extra dependencies beyond `adb`.
- Run `bash -n tools/*.sh` and, if available, `shellcheck tools/*.sh` after any change.
- `tests/test_protected.sh` must pass: it checks the PROTECTED patterns without a phone.
