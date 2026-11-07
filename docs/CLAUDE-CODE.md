<div dir="rtl">

# איך עובדים עם Claude Code — מדריך למתחילים

המדריך הזה מניח שמעולם לא פתחתם טרמינל. אם כבר יש לכם Claude Code ו‑adb, דלגו ל[שלב 4](#4-לפתוח-את-הפרויקט).

## מה זה Claude Code?

Claude Code הוא Claude שיכול **לפעול על המחשב שלכם**: לקרוא קבצים בתיקייה, להריץ פקודות ולערוך קבצים.
בפרויקט הזה הוא מריץ פקודות `adb` שמדברות עם הטלפון דרך הכבל. **לפני כל פקודה הוא מבקש אישור** — אתם רואים מה
הוא רוצה להריץ ומחליטים.

> צריך מנוי Claude בתשלום (Pro, Max, Team או Enterprise) או חשבון Anthropic Console.
> Claude Code חייב לרוץ **על המחשב שהטלפון מחובר אליו**. הגרסה בדפדפן (claude.ai/code) ובאפליקציה לטלפון רצה
> בענן ולא תראה את הטלפון.

---

## 1. להתקין את Claude Code

יש שתי דרכים. בחרו אחת.

### דרך א' — אפליקציית Claude למחשב (הכי פשוט)
1. הורידו את אפליקציית Claude ל‑[Mac](https://claude.ai/api/desktop/darwin/universal/dmg/latest/redirect) או
   ל‑[Windows](https://claude.ai/api/desktop/win32/x64/setup/latest/redirect) והתקינו.
2. היכנסו עם החשבון שלכם ולחצו על הלשונית **Code**.
3. בחרו את תיקיית הפרויקט (אחרי שלב 4). את adb עדיין צריך להתקין (שלב 2).

### דרך ב' — בטרמינל
**פותחים טרמינל:**
- **Mac:** ⌘ + רווח ← כתבו `Terminal` ← Enter.
- **Windows:** תפריט התחל ← כתבו `PowerShell` ← Enter.

**מתקינים** — העתיקו את השורה שמתאימה למחשב, הדביקו בטרמינל ולחצו Enter:

| מערכת | פקודה |
|---|---|
| Mac / Linux | `curl -fsSL https://claude.ai/install.sh \| bash` |
| Windows (PowerShell) | `irm https://claude.ai/install.ps1 \| iex` |
| Windows (winget) | `winget install Anthropic.ClaudeCode` |
| Mac (Homebrew) | `brew install --cask claude-code` |

ההתקנה לא מציגה התקדמות — חכו שתסתיים. אחר כך **סגרו ופתחו טרמינל חדש** וכתבו `claude --version`.
אם מופיע מספר גרסה — הצלחתם. ב‑Windows מומלץ להתקין גם [Git for Windows](https://git-scm.com/downloads/win).
תקלות: [מדריך פתרון בעיות ההתקנה](https://code.claude.com/docs/en/troubleshoot-install).

## 2. להתקין adb (הכלי שמדבר עם הטלפון)

| מערכת | פקודה |
|---|---|
| Mac | `brew install --cask android-platform-tools` |
| Windows | `winget install Google.PlatformTools` |
| Linux (Ubuntu/Debian) | `sudo apt install adb` |

בלי Homebrew/winget: הורידו את [Android SDK Platform-Tools](https://developer.android.com/tools/releases/platform-tools)
מגוגל, חלצו, ובקשו מ‑Claude לעזור להוסיף ל‑PATH. **אפשר גם פשוט לבקש מ‑Claude Code: "תתקין לי adb"** — הוא יציע
את הפקודה ויחכה לאישור.

בדיקה: `adb version`.

## 3. להכין את הטלפון

ראו שלב 1 ("בטלפון: להפעיל ניפוי באגים") ב‑[README](../README.md).
ב‑Windows ייתכן שתצטרכו דרייבר USB של היצרן (סמסונג: Samsung USB Driver).

## 4. לפתוח את הפרויקט

```bash
git clone https://github.com/arielgalil/cleanmyandroid.git
cd cleanmyandroid
claude
```

בלי git: בעמוד הפרויקט ב‑GitHub ← **Code** ← **Download ZIP**, חלצו, ובטרמינל:
`cd` ואחריו גררו את התיקייה לחלון הטרמינל, Enter, ואז `claude`.

בפעם הראשונה Claude Code יבקש להתחבר (נפתח דפדפן) וישאל אם אתם סומכים על התיקייה — ענו כן.
הוא קורא אוטומטית את `CLAUDE.md`, שבו כללי הבטיחות של הפרויקט.

## 5. להדביק את הפרומפט

1. פתחו את [PROMPT.md](../PROMPT.md).
2. העתיקו מהקו הראשון (`---`) עד הקו השני.
3. שנו `<MODEL NAME HERE>` לדגם שלכם (למשל `Samsung Galaxy A55`) ואת השפה ל‑`עברית`.
4. הדביקו ב‑Claude Code ולחצו Enter.

---

## איך מדברים עם Claude Code

| מצב | מה עושים |
|---|---|
| הוא מבקש אישור להריץ פקודה | קראו מה כתוב. **Yes** = רק הפעם. "Yes, and don't ask again" = לא ישאל שוב על פקודה דומה. **No** = ותגידו לו מה לעשות במקום |
| הוא שואל שאלה עם אפשרויות | בחרו בחצים ו‑Enter, או כתבו תשובה משלכם |
| הוא מבקש "בדקו בטלפון" | בדקו (שיחה, SMS, נעילה, התראות) וכתבו מה ראיתם — גם "הכול עובד" |
| משהו נשבר | כתבו בפשטות מה קרה: "אין לי צליל התראה בוואטסאפ". הוא יחזיר את הקבוצה האחרונה |
| רוצים לעצור אותו באמצע | **Esc** (פעם אחת). אחר כך כתבו מה לעשות |
| רוצים לצאת | `/exit` או Ctrl+C פעמיים |
| חזרתם אחרי הפסקה | `claude --continue` בתוך התיקייה ממשיך את השיחה האחרונה |
| שיחה חדשה מאפס | `/clear` |

### משפטים שימושיים להקליד
- "תסביר לי בעברית פשוטה מה החבילה X עושה לפני שאתה נוגע בה"
- "תראה לי את הרשימה בטבלה לפני שאתה מכבה"
- "תחזיר את כל מה שכיבית" ← מריץ `tools/restore.sh`
- "תחזיר רק את Samsung Internet"
- "היה עדכון מערכת, תבדוק מה חזר" ← `tools/check.sh`
- "סיימנו, תכבה את ניפוי הבאגים" ← `tools/finish.sh`

### כללי זהירות
- **אל תאשרו פקודה שאתם לא מבינים** — שאלו "מה הפקודה הזו עושה?". זה בסדר גמור.
- אל תאשרו `adb tcpip 5555`, `pm uninstall` בלי הסבר, או `rm`/`format`/`wipe`.
- Claude Code יכול לטעות. הכלים בפרויקט מגינים על הרכיבים הקריטיים, והכול הפיך — אבל אתם המחליטים.
- בסוף: **בטלו הרשאות ניפוי באגים** (אפשרויות מפתחים ← ביטול הרשאות לניפוי באגים ב‑USB) ותנו ל‑Claude להריץ
  `tools/finish.sh`. אחרי זה אפליקציות הבנק יעבדו שוב.

## מקורות
- [Claude Code — סקירה והתקנה](https://code.claude.com/docs/en/overview)
- [Claude Code — Quickstart](https://code.claude.com/docs/en/quickstart)
- [Android Platform-Tools](https://developer.android.com/tools/releases/platform-tools)

</div>
