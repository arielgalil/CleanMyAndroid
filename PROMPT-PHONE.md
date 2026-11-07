# The prompt for phone mode / פרומפט למצב טלפון

Use this when Claude Code runs **on the phone itself** (Termux + proot-distro, see
[phone-mode/CLAUDE-CODE-IN-TERMUX.md](phone-mode/CLAUDE-CODE-IN-TERMUX.md)). It reuses [PROMPT.md](PROMPT.md) and only
replaces what changes when the phone is also the computer. Paste everything between the two lines, fill in the
model and language.

---

I want to debloat THIS Android phone safely and reversibly. You are running inside Termux (proot Ubuntu/Debian)
on the same phone, so the phone is both the computer and the device being cleaned. My phone model is:
<MODEL NAME HERE>
Talk to me in: <עברית / English>

Read `CLAUDE.md` and `PROMPT.md` in this folder and follow `PROMPT.md` exactly, with these changes:

Connect (replaces the "Connect" section)
- There is no USB cable. Use Wireless debugging on this phone, connecting adb to `localhost`.
- Check `adb version` (it is installed with `apt install adb`). Never use `adb tcpip`.
- Tell me to turn on Wi-Fi and Developer options → Wireless debugging, and to keep Termux and Settings visible together
  (split-screen or floating window), because the pairing code disappears when its dialog closes.
- Ask me for the pairing **port** and the 6-digit **code** (from "Pair device with pairing code"), then run
  `adb pair localhost:<port> <code>`. Then ask me for the port on the main Wireless debugging screen, which is a
  different number, and run `adb connect localhost:<port>`. Ask me to tap Allow if a prompt appears.
- Wireless debugging needs Wi-Fi and a new port every time it starts. If adb disconnects, ask me to switch it off and on,
  and reconnect. Don't carry on with half a batch unverified: after any reconnect, check `pm list packages -d` first.

Differences while working
- The state in `~/.cleanyourphone/` is inside this proot, not in Android. Back up and restore from here.
  `restore.sh` still works, and without any computer I can re-enable apps in Settings → Apps → show system apps.
- There is no second device to rescue the phone. Use batches of 5 (not 10), and after each batch ask me to switch to the
  Phone app and test: lock screen, a call, a notification, Settings. Wait for my answer. A bad batch is restored at once.
- Do not touch Termux, the Termux:* apps, F-Droid or anything I installed myself. Never disable the keyboard, the
  launcher, or Settings, and never turn Wi-Fi or Wireless debugging off before the end.
- Screenshots with `tools/shot.sh` show this phone's screen; use them to check what is on screen, not to read private content.
- At the end, run `tools/finish.sh` as in PROMPT.md. It closes this connection on purpose. Tell me that before running it.

---
