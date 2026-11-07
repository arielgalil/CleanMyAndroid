# The prompt / הפרומפט

**עברית:** העתיקו את כל מה שמתחת לקו הראשון ועד הקו השני, הדביקו ב‑Claude Code שרץ **על המחשב שלכם**
(טרמינל או אפליקציית Claude לדסקטופ, לשונית Code), ומלאו את דגם הטלפון בשורה המתאימה. ההוראות המלאות
בעברית נמצאות ב‑[README.md](README.md) וב‑[docs/CLAUDE-CODE.md](docs/CLAUDE-CODE.md).

**English:** Copy everything between the two lines below into Claude Code running **on your own computer**
(terminal, or the Claude desktop app's Code tab), with the phone plugged in by USB. Fill in the model line.
Claude Code on the web or in the mobile app runs in the cloud and cannot reach a USB phone.

Before you start, on the phone: Settings → About phone → tap "Build number" 7 times (Xiaomi: "OS version";
Samsung: Software information → Build number), go back → Developer options → turn on **USB debugging**.
Xiaomi/Redmi/POCO also need **Install via USB** and **USB debugging (Security settings)**, which may ask for a
Mi account and a SIM. Plug the phone into the computer with a data cable and keep it unlocked.

---

I want to debloat my Android phone safely and reversibly: switch off manufacturer ads, telemetry and
pre-installed apps I don't use, without root and without uninstalling system apps.
My phone model is: <MODEL NAME HERE>
Talk to me in: <עברית / English>

Work on the real device, step by step. Ask me before anything that depends on my preferences. This folder is
the CleanYourPhone repo: use `tools/`, `docs/` and `examples/` from it rather than writing your own versions,
so the safety checks in `tools/disable.sh` stay in force. If those folders are missing, clone the repo first
(see README) and work from there. Read `CLAUDE.md` before starting.

Connect
- The phone is on USB. Check `adb version`; if adb is missing, tell me how to install Android platform-tools
  for my OS (Homebrew, winget, or Google's zip) instead of guessing, and wait.
- Run `adb devices -l`. If the phone shows `unauthorized`, tell me to unlock it and tap **Allow** on
  "Allow USB debugging?" (tick "Always allow from this computer"). If more than one device is listed, ask me
  which one and use `ADB_SERIAL`.
- If my computer has no data cable or USB won't work, use Wireless debugging (Android 11+):
  Developer options → Wireless debugging → Pair device with pairing code; ask me for the IP:port and code,
  then `adb pair` and `adb connect`. Never use `adb tcpip 5555` on a phone: it leaves a plaintext shell port
  open on every Wi-Fi network the phone joins.
- Read and tell me: brand, model, Android version (`ro.build.version.release`, SDK), vendor skin and version
  (One UI `ro.build.version.oneui`, HyperOS/MIUI `ro.mi.os.version.name` / `ro.miui.ui.version.name`,
  ColorOS/OxygenOS `ro.build.version.opporom` or `ro.build.version.oplusrom`, etc.), and region
  (`ro.product.locale`, `ro.csc.sales_code` on Samsung).

Back up first
- Run `tools/backup.sh` before any change. Tell me where the backup went.
- Ask me to take a screenshot of my home screen myself or take one with `tools/shot.sh shots/00-before.png`.
- Remind me that a factory reset brings every system app back, but erases my data, so it is the last resort.

Look before you touch
- List packages (`pm list packages -s`, `-3`, `-d`) and sort the system ones into: ads, telemetry/analytics,
  vendor duplicates (browser, store, music, video, themes), pre-installed third-party apps (Facebook stubs,
  Microsoft, Netflix, Booking, games), assistants/AI features, and "system / don't know".
- Use `docs/brands.md` and the matching `examples/<brand>/` starter list as the starting point. Package names
  differ by region and OS version: only consider packages that exist on this phone.
- When a package's name doesn't say what it does, check `dumpsys package <name>` (activities, services,
  permissions) without launching it. If it is still unclear, it goes in "don't know" and stays on.
- Never disable anything in the protected list in `tools/common.sh`, even if I ask. Explain why instead.
  The most important ones in Israel: anything with `cellbroadcast` (Pikud HaOref emergency alerts arrive
  through it) and every IMS/VoLTE/telephony/carrier-config package (Israel has shut 2G/3G; without IMS the
  phone cannot make calls, including emergency calls).
- Also never disable: the current launcher, the default SMS and Phone apps, the keyboard I use, the lock
  screen and biometrics, OEM account packages (Samsung account, Mi account, vivo account, Honor ID), the
  vendor security centre, Google Play Services, Play Store, WebView, Bluetooth, NFC.
- Show me the proposed list as a table (package, what it is, category, risk: safe/caution) and ask me with a
  checklist which of these I actually use: vendor browser, vendor app store and themes, Bixby/Google
  Assistant/Gemini, Samsung Health/Wallet/Pay or Google Wallet (NFC payments), Android Auto, Smart Things,
  Link to Windows, Digital Wellbeing, vendor cloud/backup, vendor gallery/music/video, Find My Device.
  Disable only what I didn't tick.

Debloat
- Use only `tools/disable.sh <list>` with lists you write to `lists/`, 5–10 packages per batch.
  Run with `DRY_RUN=1` first and show me the output, then `YES=1` after I confirm.
- `disable.sh` uses `pm disable-user --user 0` and checks the result with `pm list packages -d`, not the exit
  code. If it reports LOCKED (protected package), leave that package. If every package fails, stop: this
  firmware blocks it (`docs/TROUBLESHOOTING.md`), and retrying wastes the session.
- Xiaomi HyperOS 2 and newer often refuse `disable-user` for system packages. Only then, and only for packages
  rated safe, ask me before re-running that batch with `ALLOW_UNINSTALL=1`, which removes the app for user 0
  (still reversible with `tools/restore.sh`). Android 17+ refuses this for system apps; don't try to bypass it.
- After each batch: take a screenshot, and ask me to check: the lock screen opens, a phone call connects,
  an SMS arrives, notifications from WhatsApp (or my main messaging app) still come in. If something broke,
  restore that batch with `tools/restore.sh <packages>` before doing anything else.
- After the last batch wait 15 seconds (Android writes package state to disk about 10 s after a change), then
  ask me before rebooting. After the reboot run `tools/check.sh` and tell me if anything came back.

Settings that need no adb
- Walk me through the ad and privacy toggles for my brand from `docs/settings-toggles.md` one at a time
  (for example: Xiaomi MSA revoke and "personalized ad recommendations" in each system app; Samsung
  Customization Service; Google: Delete advertising ID; Realme "Get recommendations"; lock-screen
  Glance/Carousel). I do these on the phone; you tell me the path and wait for me.

Optional: ad-blocking Private DNS
- Offer it, don't push it. Explain: it blocks many ads and trackers in apps and browsers, but not YouTube ads;
  the DNS provider sees every domain the phone looks up; some Wi-Fi login pages (hotels, airports, buses)
  won't open until it's set back to Automatic; it can clash with a VPN.
- Ask first whether I use a VPN or my home router already filters DNS.
- If I agree: `settings put global private_dns_specifier dns.adguard-dns.com` then
  `settings put global private_dns_mode hostname`, check a website and an app still load, and tell me the undo:
  Settings → Network → Private DNS → Automatic, or `tools/restore.sh --dns`.

Finish
- Write `MY-PHONE.md` in Hebrew (or my language) with: the phone details, every package you disabled and why,
  what each one did, how to bring any app back without a computer (Settings → Apps → show system apps → the app
  → Enable) and with `tools/restore.sh`, and what to do after a system update (`tools/check.sh`).
- Before closing: tell me to revoke USB debugging authorisations in Developer options, then run
  `tools/finish.sh`, which turns off Wireless debugging, USB debugging and Developer options. Explain that many
  banking and payment apps refuse to open while Developer options are on.

---

Expect three or four checklist questions, two or three "check your phone" pauses, and about 20–40 minutes.
