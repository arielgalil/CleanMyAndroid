# Brand notes / הערות לפי יצרן

Ratings: **safe** = no core feature lost (still check on your phone) · **caution** = you lose a feature, or
reports are mixed · **never** = blocked in `tools/common.sh`. Package names change with region and OS version:
only consider what `pm list packages` shows on the phone. Sources: UAD-NG lists and wiki, XDA threads, GitHub
issues and vendor forums, collected November 2026. Ratings marked *(judgment)* are inferred, not tested.

<div dir="rtl">

**בקצרה:** סמסונג היא הכי "משתפת פעולה". שיאומי (HyperOS 2+) חוסמת השבתה של חלק מהחבילות. אופו/ריאלמי/וואנפלוס
לפעמים "מסכימות" ולא עושות כלום. ויוו חוסמת חלק מהאפליקציות שלה. בכל המותגים — עדכון מערכת גדול עלול להחזיר
אפליקציות, ואז מריצים `tools/check.sh`.

</div>

## Every brand
| Never | Why |
|---|---|
| `*cellbroadcast*` | Pikud HaOref "personal message" emergency alerts arrive through it (live since Aug 2024, used Oct 2024) |
| IMS / VoLTE: `com.sec.ims*`, `com.samsung.advp.imssettings`, `com.qualcomm.qti.ims`, `com.mediatek.ims`, `com.google.android.ims`, `com.huawei.ims`, `com.shannon.*` | Israel turned off 2G/3G: no IMS = no calls, no emergency calls |
| `com.android.phone`, `com.android.server.telecom`, `com.android.providers.*`, `com.android.stk`, carrier config, OMACP | Calls, SMS, SIM, APN |
| Launcher in use, default SMS/Phone apps, keyboard, lock screen, biometrics | You can't use the phone |
| OEM account (Samsung/Mi/vivo/Honor), security centre | Lock-screen lock-out, Find My Device |
| `com.google.android.gms`, `com.google.android.gsf`, `com.android.vending`, WebView | Most apps stop working |

Facebook stubs (`com.facebook.appmanager`, `com.facebook.services`, `com.facebook.system`) are **safe** on every brand.

## Samsung (One UI 6 / 7 / 8)
| Package | What | Rating |
|---|---|---|
| com.samsung.android.rubin.app | Customization Service (profiling) | safe |
| com.samsung.android.beaconmanager | Beacon tracking | safe |
| com.samsung.android.app.spage | Samsung Free / Bixby home page | safe |
| com.samsung.android.bixby.agent, .bixby.wakeup, com.samsung.android.app.settings.bixby, com.samsung.systemui.bixby2, com.samsung.android.bixbyvision.framework, com.samsung.android.visionintelligence | Bixby | safe (no Bixby) |
| com.samsung.android.aremoji, .aremojieditor, .ardrawing, .stickercenter | AR Emoji / stickers | safe |
| com.samsung.android.voc | Samsung Members | safe |
| com.samsung.android.app.tips | Tips | safe |
| com.sec.android.app.sbrowser | Samsung Internet | safe if you use another browser |
| com.microsoft.skydrive, com.microsoft.appmanager | OneDrive, Link to Windows | safe (no Phone Link) |
| com.glance.ailockscreen | Glance lock-screen content | safe |
| com.samsung.android.app.routines | Modes & Routines | caution |
| com.sec.android.app.samsungapps | Galaxy Store | caution: Samsung app updates and themes |
| com.samsung.android.themestore | Themes | caution |
| com.samsung.android.mapsagent, .privateaccesstokens, .fast | misc services | caution |
| com.samsung.android.app.clockpack, .dynamiclock | Lock-screen clock | **never** (clock disappears) |
| com.osp.app.signin | Samsung account | **never** |
| Secure Folder / managed provisioning / Knox containers | Work profile | **never** (One UI crash-loops) |

Gotchas: some packages (parts of Quick Share) answer "Cannot disable a protected package" — leave them.
No-adb: Settings → Security and privacy → Customization Service → off; Settings → Google → Ads → Delete advertising ID.

## Xiaomi / Redmi / POCO (MIUI 14, HyperOS 1–3)
| Package | What | Rating |
|---|---|---|
| com.miui.msa.global | MSA – system ads | safe |
| com.miui.analytics | Analytics | safe |
| com.xiaomi.mipicks | GetApps store | safe |
| com.mi.globalbrowser | Mi Browser | safe |
| com.miui.videoplayer, com.miui.player | Mi Video / Music | safe |
| com.miui.android.fashiongallery | Wallpaper Carousel | safe |
| com.miui.hybrid, com.miui.hybrid.accessory | Quick Apps | safe |
| com.miui.daemon, com.miui.bugreport | Diagnostics | caution |
| com.xiaomi.joyose | Thermal/game profiles + cloud | caution |
| com.xiaomi.discover | System app updater | caution |
| com.miui.yellowpage | Caller ID | caution |
| com.xiaomi.aicr | AI engine | caution |
| com.miui.cloudservice | Mi Cloud | caution (Find Device) |
| com.xiaomi.account, com.miui.securitycenter | Account, Security | **never** |

Gotchas:
- ADB needs **Install via USB** and **USB debugging (Security settings)**; many builds want a Mi account and SIM.
- HyperOS 2+ often throws "Cannot disable system packages" / "miui core packages". `disable.sh` reports FAIL;
  re-run that batch with `ALLOW_UNINSTALL=1` (removes for user 0, reversible). Android 17-based HyperOS refuses that too.
- Major updates bring MSA and others back: run `tools/check.sh`.

## Google Pixel
Close to stock; little to remove.
| Package | What | Rating |
|---|---|---|
| com.google.android.as | Android System Intelligence | caution: Live Caption, Now Playing, Smart Reply, smart text selection |
| com.google.android.googlequicksearchbox | Google app | caution: Assistant, At a Glance, Discover |
| com.google.android.apps.wellbeing | Digital Wellbeing | caution: Bedtime, Focus, parental controls |
| com.google.android.projection.gearhead | Android Auto | caution |
| com.google.android.ims, com.shannon.* | Carrier Services, modem | **never** |

## OnePlus / Oppo / Realme (OxygenOS, ColorOS, realme UI)
| Package | What | Rating |
|---|---|---|
| com.opos.ads | Ad service | safe, often refused |
| com.heytap.mcs | "System messages" promotions | safe |
| com.nearme.statistics.rom | User experience program | safe |
| com.heytap.browser | Browser | safe |
| com.heytap.pictorial | Lock-screen magazine | safe |
| com.heytap.music, com.coloros.video | Media | safe |
| com.heytap.speechassist, com.heytap.quicksearchbox | Breeno voice / search | safe |
| com.glance.internet | Glance (Realme) | safe |
| com.heytap.openid | Ad ID | caution |
| com.heytap.market | App Market | caution: system app updates |
| com.heytap.themestore | Themes | caution (disable, never uninstall) |
| com.heytap.cloud | Cloud | caution |
| com.coloros.assistantscreen | Shelf | caution: some launchers lose the widget picker |
| com.coloros.phonemanager | Phone Manager | caution: payment protection |
| com.oplus.*, com.coloros.safecenter | System / security | **never** (blocked as a prefix) |

Gotchas: ColorOS answers "new state: default" when it silently refuses. `disable.sh` checks the real state, so
this shows up as FAIL — don't retry. Updates and the App Market can re-enable apps.
No-adb: Realme Settings → Additional settings → **Get recommendations** → off; recommendations off in App Market, Themes, Phone Manager.

## Motorola
| Package | What | Rating |
|---|---|---|
| com.motorola.demo, com.motorola.help, com.motorola.genie | Demo, help, feedback | safe |
| com.glance.lockscreenM | Glance lock-screen ads | safe |
| com.motorola.brapps | Moto App Box | safe |
| com.motorola.ccc.ota | Update service | caution, often protected |
| com.motorola.ccc.devicemanagement | Device management | caution |
| com.motorola.launcher3 | Launcher | never while it is Home |

## Nothing (Nothing OS 3 / 4)
| Package | What | Rating |
|---|---|---|
| com.vilykke.lockscreen | "Lock Glimpse" lock-screen content (3a series) | safe |
Nothing removed Lock Glimpse from the Phone (a) series in a January 2026 update; on others it is off by default.

## Vivo / iQOO (Funtouch, OriginOS)
| Package | What | Rating |
|---|---|---|
| com.vivo.browser | Browser | safe |
| com.vivo.assistant, com.vivo.agent | Jovi | safe |
| com.vivo.hiboard, com.vivo.globalsearch | -1 screen, search | safe |
| com.vivo.magazine | Lock-screen magazine | safe |
| com.vivo.game, com.vivo.space, com.vivo.website, com.iqoo.website | Promo apps | safe |
| com.android.bbkmusic | i Music | safe |
| com.bbk.appstore / com.vivo.appstore, com.bbk.theme, com.bbk.cloud | Store, themes, cloud | caution |
| com.vivo.pem, com.iqoo.secure, com.bbk.account, com.android.bbk.lockscreen3 | Power, security, account, lock screen | **never** (pem: missing notifications) |

Gotchas: Funtouch 12/13 returns `DELETE_FAILED_USER_RESTRICTED` for its own apps. Don't use binder (`service call`) bypasses.

## Honor (MagicOS) — brief
safe: com.hihonor.tips / com.hihonor.android.tip, com.hihonor.appmarket · caution: com.hihonor.phoneservice,
com.hihonor.systemappsupdater · **never**: com.hihonor.phoneservices (SIM management), Honor ID.

## Huawei (EMUI, no Google) — brief
Community lists disagree. **Never**: com.huawei.systemmanager, com.huawei.android.hwouc, com.huawei.ims,
com.huawei.omacp, com.huawei.android.dsdscardmanager. Candidates: com.huawei.wallet.sdk.walletsdk,
com.huawei.hwpanpayservice.

## Israeli carriers
No confirmed list of pre-installed Partner / Cellcom / Pelephone / HOT Mobile / Golan / 019 packages. Carrier
packages can carry APN and VoLTE provisioning: show them to the person as "carrier — unknown" and leave them on
unless they clearly are a store or promo app.

## Sources
- UAD-NG [FAQ](https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/wiki/FAQ),
  [Android 17 announcement #1440](https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/discussions/1440),
  [How to contribute](https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/wiki/How-to-contribute)
- [MuntashirAkon/android-debloat-list](https://github.com/MuntashirAkon/android-debloat-list)
- [Brevent #902 — HyperOS canBeDisabled](https://github.com/brevent/Brevent/issues/902)
- [XDA ColorOS 15 debloat](https://xdaforums.com/t/coloros-15-debloat.4709960/) ·
  [XDA Funtouch 11–13](https://xdaforums.com/t/debloat-funtouch-os-11-13-iqoo-7.4306269/)
- [AOSP Cell Broadcast module](https://source.android.com/docs/core/ota/modular-system/cellbroadcast)
- [Times of Israel — location-based alerts](https://www.timesofisrael.com/liveblog_entry/idf-can-now-send-location-based-alerts-to-phones-in-case-of-large-scale-attacks/)
- [Android Authority — Android System Intelligence](https://www.androidauthority.com/android-system-intelligence-3325187/)
- [UAD-NG Honor PR #1347](https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/pull/1347)
