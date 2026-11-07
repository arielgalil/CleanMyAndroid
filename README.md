<div dir="rtl">

# CleanYourPhone — טלפון אנדרואיד, בלי הפרסומות

**[English version below](#english) · [README.en.md](README.en.md)**

כיבוי פרסומות, מעקב ואפליקציות מותקנות־מראש בטלפון אנדרואיד — בלי root, בלי למחוק כלום, והכול הפיך בפקודה אחת.
הפרויקט מבוסס על הרעיון של [CleanYourTV](https://cleanyour.tv) (שעושה את זה לטלוויזיות אנדרואיד), מותאם לטלפונים
ולישראל.

**איך זה עובד:** אתם לא מקלידים פקודות. מחברים את הטלפון למחשב, מדביקים פרומפט ב‑**Claude Code**, והוא עושה את
העבודה צעד אחרי צעד — שואל אתכם לפני כל דבר שתלוי בהעדפות שלכם, ומבקש מכם לבדוק שהטלפון עדיין עובד.

> ⚠️ **חשוב לישראל:** הכלים חוסמים בקוד כיבוי של רכיבי **התרעות פיקוד העורף** (Cell Broadcast — "הודעה אישית")
> ושל רכיבי **VoLTE/IMS**. רשתות 2G/3G בישראל נסגרו, ובלי VoLTE הטלפון לא יכול להתקשר — גם לא למוקדי חירום.

---

## מה צריך

| | |
|---|---|
| 📱 טלפון אנדרואיד | סמסונג, שיאומי/רדמי/פוקו, פיקסל, וואנפלוס/אופו/ריאלמי, מוטורולה, נאת'ינג, ויוו ועוד |
| 💻 מחשב | Windows, Mac או Linux |
| 🔌 כבל USB | כבל **נתונים** (לא כבל טעינה בלבד) |
| 🤖 Claude Code | דורש מנוי Claude בתשלום. מדריך התקנה בעברית: **[docs/CLAUDE-CODE.md](docs/CLAUDE-CODE.md)** |
| ⏱️ זמן | 20–40 דקות, בישיבה אחת |

> Claude Code צריך לרוץ **על המחשב שאליו הטלפון מחובר** — בטרמינל או בלשונית Code של אפליקציית Claude למחשב.
> Claude Code בדפדפן או באפליקציה לטלפון רץ בענן ולא יכול לראות טלפון שמחובר ב‑USB.

## שלושה צעדים

### 1. בטלפון: להפעיל ניפוי באגים (USB debugging)

1. **הגדרות ← אודות הטלפון** ← הקישו 7 פעמים על **מספר Build**.
   - סמסונג: הגדרות ← אודות הטלפון ← **מידע על תוכנה** ← מספר Build.
   - שיאומי/רדמי/פוקו: הגדרות ← אודות הטלפון ← **גרסת OS** (או "גרסת MIUI").
   - פיקסל: הגדרות ← אודות הטלפון ← מספר Build.
2. חזרו להגדרות ← **מערכת** (בשיאומי: **הגדרות נוספות**) ← **אפשרויות מפתחים**.
3. הפעילו **ניפוי באגים ב‑USB**.
   - **בשיאומי** הפעילו גם **התקנה דרך USB** וגם **ניפוי באגים ב‑USB (הגדרות אבטחה)**. ייתכן שיידרש חשבון Mi
     מחובר וכרטיס SIM בטלפון.
4. חברו את הטלפון למחשב בכבל, ובחרו "העברת קבצים" אם הטלפון שואל.

### 2. במחשב: לפתוח את הפרויקט ב‑Claude Code

```bash
git clone https://github.com/arielgalil/cleanmyandroid.git
cd cleanmyandroid
claude
```

אין לכם git? הורידו את ה‑ZIP מכפתור **Code ← Download ZIP** בעמוד הזה, חלצו, ופתחו את התיקייה.
מדריך מלא, כולל התקנת Claude Code ו‑adb: **[docs/CLAUDE-CODE.md](docs/CLAUDE-CODE.md)**.

### 3. להדביק את הפרומפט ולענות לשאלות

פתחו את **[PROMPT.md](PROMPT.md)**, העתיקו את החלק שבין שני הקווים, שנו את שורת הדגם ואת שפת השיחה
(`עברית`), והדביקו ב‑Claude Code. כשיופיע בטלפון **"לאפשר ניפוי באגים ב‑USB?"** — הקישו **אפשר**.

מה יקרה:
1. גיבוי מלא של רשימת האפליקציות וההגדרות.
2. Claude יציג טבלה של מה שמוצע לכבות, ויבקש מכם לסמן במה אתם משתמשים.
3. כיבוי בקבוצות קטנות (5–10). אחרי כל קבוצה: בדקו שיחה, SMS, מסך נעילה והתראות.
4. מעבר על הגדרות פרטיות ופרסומות שעושים ידנית בטלפון ([docs/settings-toggles.md](docs/settings-toggles.md)).
5. אופציונלי: DNS שחוסם פרסומות.
6. סיכום בעברית בקובץ `MY-PHONE.md`, וכיבוי ניפוי הבאגים.

---

## האם זה בטוח?

- **שום דבר לא נמחק.** אפליקציות מערכת "מושבתות" (כמו הכפתור "השבת" בהגדרות), לא מוסרות.
- **פקודה אחת מחזירה הכול:** `tools/restore.sh`. וגם בלי מחשב: הגדרות ← אפליקציות ← הצגת אפליקציות מערכת ←
  האפליקציה ← **הפעל**.
- **רשימת הגנה בקוד** (`tools/common.sh`): התרעות חירום, שיחות ו‑VoLTE, מקלדת, מסך נעילה וביומטריה, חשבון
  היצרן, Play Services, ה‑Launcher הנוכחי, אפליקציית ה‑SMS והחייגן ברירת המחדל — הסקריפט מסרב לגעת בהם.
- **איפוס יצרן** מחזיר את כל אפליקציות המערכת (אבל מוחק את המידע שלכם) — זה המוצא האחרון, וכמעט אף פעם לא נדרש.

## שאלות נפוצות

**האפליקציות של הבנק / bit / PayBox לא נפתחות.**
אפליקציות תשלום רבות מסרבות לעבוד כש"אפשרויות מפתחים" פעילות. בסוף העבודה Claude מריץ `tools/finish.sh`
שמכבה אותן. אם שכחתם: הגדרות ← מערכת ← אפשרויות מפתחים ← כיבוי המתג העליון.

**אחרי עדכון מערכת חלק מהאפליקציות חזרו.**
זה קורה, בעיקר בשיאומי ובאופו/ריאלמי. פתחו שוב את Claude Code בתיקייה וכתבו: "הרץ tools/check.sh ותקן מה שחזר".

**בשיאומי כתוב שאי אפשר להשבית.**
ב‑HyperOS 2 ומעלה שיאומי חוסמת השבתה של חלק מאפליקציות המערכת. Claude יציע (רק אם תאשרו) הסרה למשתמש
הנוכחי — עדיין הפיכה עם `tools/restore.sh`. באנדרואיד 17 גם זה נחסם.

**זה ישבור את האחריות?**
לא נוגעים ב‑bootloader ולא ב‑root. ההשבתה זהה למה שאפשר לעשות ידנית מההגדרות.

**האם זה חוסם פרסומות ביוטיוב / באינסטגרם?**
לא. זה מכבה את הפרסומות **של יצרן הטלפון** (בהגדרות, במסך הנעילה, באפליקציות המערכת). DNS חוסם פרסומות
(אופציונלי) עוזר באפליקציות ובאתרים רבים, אבל לא ביוטיוב.

## מבנה הפרויקט

```
PROMPT.md              הפרומפט להדבקה
CLAUDE.md              כללי עבודה ל-Claude Code בתיקייה הזו
tools/                 סקריפטים: backup, disable, restore, check, shot, finish
examples/<brand>/      רשימות התחלה לפי יצרן
docs/                  מדריכים: Claude Code, יצרנים, הגדרות ידניות, פתרון תקלות
tests/                 בדיקת רשימת ההגנה (בלי טלפון)
```

## תודות ורישיון

רעיון, מבנה וחלק מעקרונות הבטיחות: [CleanYourTV](https://github.com/Gathin23/cleanyourtv) מאת Gathin.
מידע על חבילות: [Universal Android Debloater NG](https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation),
פורומי XDA ותרומות קהילה. הפרויקט אינו קשור לאף יצרן ולא ל‑Anthropic. רישיון MIT. השימוש באחריותכם.

</div>

---

<a id="english"></a>
## English

**CleanYourPhone** switches off manufacturer ads, telemetry and pre-installed apps on Android phones over
ADB — no root, nothing uninstalled, one command to undo. It adapts [CleanYourTV](https://cleanyour.tv) to
phones, with Israel-specific safety: emergency alerts (cell broadcast) and VoLTE/IMS are hard-blocked in code.

1. On the phone: enable Developer options and **USB debugging** (Xiaomi: also *Install via USB* and
   *USB debugging (Security settings)*). Plug it into your computer.
2. On the computer: `git clone` this repo, `cd` into it, run `claude` (Claude Code, local — not the web version).
   Setup guide: [docs/CLAUDE-CODE.md](docs/CLAUDE-CODE.md) (Hebrew) · [README.en.md](README.en.md).
3. Paste the prompt from [PROMPT.md](PROMPT.md), fill in your model, answer the checklist questions.

Undo: `tools/restore.sh`, or Settings → Apps → show system apps → Enable. Full English guide: [README.en.md](README.en.md).
