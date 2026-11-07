<div dir="rtl">

# Claude Code על הטלפון עצמו (Termux + proot-distro)

במקום התפריט הפשוט, אפשר להריץ את **Claude Code** בתוך Ubuntu או Debian שרצים ב‑Termux (דרך `proot-distro`),
ולתת לו לנקות את אותו הטלפון, בדיוק כמו בפרומפט הרגיל: הוא מסביר, שואל, מגבה ובודק.

> ⚠️ **סטטוס: לא נבדק על מכשיר אמיתי.** לפי התיעוד הרשמי Claude Code נתמך על Ubuntu 20.04+ ו‑Debian 10+ עם מעבד
> ARM64 וזיכרון של 4GB ומעלה. הרצה בתוך proot על אנדרואיד **אינה מוזכרת שם**, ויכולות להופיע בעיות (ביצועים, חיבור,
> התחברות). אם משהו נתקע — חזרו לתפריט הפשוט ([README.md](README.md)), שהוא הדרך שנבדקה.
> **אותה מגבלה:** אם הטלפון נשבר, אין מחשב נוסף לשחזר ממנו. נסו קודם על טלפון משני.

## מה צריך
- אנדרואיד 11 ומעלה, Wi‑Fi פעיל, ובערך 4GB פנויים וזיכרון RAM מספיק (Claude Code מבקש 4GB+).
- מנוי Claude (Pro, Max, Team או Enterprise) או חשבון Console.
- Termux מ‑[F‑Droid](https://f-droid.org) (לא מ‑Google Play).

## התקנה (פעם אחת)

ב‑Termux:
```bash
pkg update && pkg install proot-distro git
proot-distro install ubuntu
proot-distro login ubuntu
```

עכשיו אתם **בתוך Ubuntu**. שם:
```bash
apt update && apt install -y curl git adb ca-certificates
curl -fsSL https://claude.ai/install.sh | bash
```
ההתקנה לא מציגה התקדמות — חכו שתסתיים, ואז:
```bash
export PATH="$HOME/.local/bin:$PATH"
claude --version
git clone https://github.com/arielgalil/cleanmyandroid.git
cd cleanmyandroid
```

**התחברות:** הריצו `claude`. אם הוא מציג קישור, פתחו אותו בדפדפן של הטלפון, התחברו, והעתיקו את הקוד
בחזרה ל‑Termux. אם אין תגובה, אפשר להשתמש במפתח API: `export ANTHROPIC_API_KEY=...`
(ראו [תיעוד ההתחברות](https://code.claude.com/docs/en/authentication)).

## הפעלה

1. Wi‑Fi פעיל. אפשרויות מפתחים ← **ניפוי באגים אלחוטי** ← הפעילו.
2. חלון מפוצל או צף: Termux לצד ההגדרות.
3. ב‑Ubuntu, בתיקיית הפרויקט: `claude`.
4. הדביקו את הפרומפט מתוך **[PROMPT-PHONE.md](../PROMPT-PHONE.md)** (ממלאים דגם ושפה).
5. כש‑Claude יבקש — הקלידו לו את **הפורט והקוד** מחלון "התאמה באמצעות קוד התאמה", ואחר כך את הפורט מהמסך הראשי של
   ניפוי האלחוטי. הוא יריץ `adb pair` ו‑`adb connect` על `localhost`.
6. מכאן הכול כמו בדרך הרגילה: גיבוי, טבלה, קבוצות קטנות, בדיקות.

בפעמים הבאות: `proot-distro login ubuntu`, ואז `cd cleanmyandroid && claude`, וחיבור אלחוטי חדש (פורט חדש בכל פעם).

## טיפים
- השאירו את Termux על המסך; אנדרואיד 12+ עלול להרוג תהליכי רקע. אם החיבור נפל: `adb kill-server`, ואז חיבור מחדש.
- כדי לבדוק שיחה או הודעה עוברים לאפליקציה אחרת וחוזרים. Claude ימתין לתשובה שלכם.
- זכרון נמוך? סגרו אפליקציות כבדות. אם Claude Code קורס או נתקע — הפעילו מחדש.
- בסוף: Claude יריץ `tools/finish.sh`, שמכבה את ניפוי הבאגים, והחיבור ייסגר.

</div>
