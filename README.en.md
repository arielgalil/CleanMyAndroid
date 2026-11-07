# CleanYourPhone — your Android phone, minus the vendor ads

**[עברית](README.md)**

Switches off manufacturer ads, telemetry and pre-installed apps on Android phones over ADB. No root, nothing
uninstalled, one command undoes it. Adapted from [CleanYourTV](https://cleanyour.tv) (which does this for
Android TVs) for phones, with safety rules for Israel built in.

You don't type commands: plug the phone into your computer, paste a prompt into **Claude Code**, and it works
through the phone step by step, asking before anything that depends on your preferences.

> **Israel:** the tools refuse, in code, to touch **Home Front Command emergency alerts** (cell broadcast,
> the "personal message" system) and **VoLTE/IMS**. Israel has shut down 2G/3G; without VoLTE the phone
> cannot call, emergency numbers included.

## You need
- An Android phone (Samsung, Xiaomi/Redmi/POCO, Pixel, OnePlus/Oppo/Realme, Motorola, Nothing, Vivo and others)
- A Windows, Mac or Linux computer and a USB **data** cable
- Claude Code (paid Claude plan or Anthropic Console account), running **locally** — the terminal or the
  Code tab of the Claude desktop app. Claude Code on the web or in the mobile app runs in the cloud and cannot
  see a USB phone.
- `adb` (Android platform-tools): `brew install --cask android-platform-tools` · `winget install Google.PlatformTools` · `sudo apt install adb`
- 20–40 minutes in one sitting

## No computer? Phone mode
You can also run everything on the phone itself with Termux and Wireless debugging, using a guided menu:
[phone-mode/README.md](phone-mode/README.md) (Hebrew guide, English menu). Claude Code can also run on the phone inside proot-distro: [guide](phone-mode/CLAUDE-CODE-IN-TERMUX.md) and [PROMPT-PHONE.md](PROMPT-PHONE.md) (untested on a real device). Try it on a spare phone first: if something breaks,
there is no second device to restore from.

## Three steps
1. **Phone:** Settings → About phone → tap *Build number* 7 times (Samsung: Software information → Build number;
   Xiaomi: OS version). Developer options → **USB debugging** on. Xiaomi: also *Install via USB* and
   *USB debugging (Security settings)* (may need a Mi account and a SIM). Plug it in.
2. **Computer:**
   ```bash
   git clone https://github.com/arielgalil/cleanmyandroid.git
   cd cleanmyandroid
   claude
   ```
   Install Claude Code: `curl -fsSL https://claude.ai/install.sh | bash` (Mac/Linux) or
   `irm https://claude.ai/install.ps1 | iex` (Windows PowerShell). See the
   [official docs](https://code.claude.com/docs/en/overview).
3. **Paste** the prompt from [PROMPT.md](PROMPT.md), fill in your model and language, and tap **Allow** on the
   phone's "Allow USB debugging?" prompt.

What happens: a backup; a table of proposed packages and a checklist of what you use; small batches with a
call/SMS/lock-screen/notification test after each; the no-adb privacy toggles for your brand; optional
ad-blocking Private DNS; a summary in `MY-PHONE.md`; debugging switched off at the end.

## Safety
- `pm disable-user --user 0` only. Uninstall-for-user is an opt-in fallback for Xiaomi HyperOS 2+, still
  reversible, and skipped on Android 17+.
- `tools/restore.sh` undoes everything. Without a computer: Settings → Apps → show system apps → Enable.
- A protected list in `tools/common.sh`: emergency alerts, telephony/IMS, keyboard, lock screen, biometrics,
  OEM accounts, Play Services, WebView, the current launcher, default SMS and Phone apps.
- A factory reset restores all system apps (and erases your data) — the last resort.

## Working with Claude Code
- It asks before each command: read it, approve with **Yes**, or say **No** and what to do instead.
- **Esc** interrupts. `/exit` leaves. `claude --continue` resumes the last session in this folder.
- Useful lines: "explain package X before you touch it", "show me the list as a table first",
  "restore everything", "there was a system update, check what came back", "we're done, turn debugging off".
- Never approve `adb tcpip 5555`, unexplained `pm uninstall`, or `rm`/`wipe`.

## Layout
```
PROMPT.md            the prompt to paste
CLAUDE.md            rules Claude Code follows in this folder
tools/               backup, disable, restore, check, shot, finish (bash over adb)
examples/<brand>/    starter lists
docs/                brands.md, settings-toggles.md (Hebrew), TROUBLESHOOTING.md, CLAUDE-CODE.md (Hebrew)
phone-mode/          Termux menu for running it on the phone itself
tests/               protected-list checks, no phone needed
```

## Credits
Idea, structure and several safety lessons: [CleanYourTV](https://github.com/Gathin23/cleanyourtv).
Package knowledge: [UAD-NG](https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation),
[MuntashirAkon/android-debloat-list](https://github.com/MuntashirAkon/android-debloat-list), XDA. Not affiliated
with any phone maker or with Anthropic. MIT licence. Use at your own risk.
