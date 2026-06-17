# Screenshot & Submission Checklist

This checklist maps every graded deliverable to the exact action needed.
Run the app on an emulator/device (`flutter run`) and capture each screenshot
with the **exact file name** shown. Use `flutter screenshot --out=NAME.png`
or the emulator's screenshot button.

> Figma evidence (`figma-evidence1` / `figma-evidence2`) is already supplied in
> the project root — no action needed for those two.

---

## A. Links to submit (no screenshot — just paste the GitHub URL)

| Pts | Deliverable | Link to submit |
|----|---|---|
| 2 | Public repo | Repo home page URL. **Set repo visibility to Public** in GitHub → Settings → Danger Zone. |
| 9 | User stories `.md` | `…/blob/main/USER_STORIES.md` |
| 4 | Sign-up implementation | `…/blob/main/lib/screens/auth/signup_screen.dart` (logic: `…/lib/services/auth_service.dart`) |
| 4 | Login implementation | `…/blob/main/lib/screens/auth/login_screen.dart` |
| 4 | Home screen implementation | `…/blob/main/lib/screens/home/home_screen.dart` |
| 4 | Detail screen implementation | `…/blob/main/lib/screens/detail/detail_screen.dart` |
| 4 | Local storage implementation | `…/blob/main/lib/services/storage_service.dart` |
| 4 | API integration | `…/blob/main/lib/services/api_service.dart` |
| 4 | Settings menu implementation | `…/blob/main/lib/screens/settings/settings_menu_screen.dart` |
| 4 | Settings screen implementation | `…/blob/main/lib/screens/settings/settings_screen.dart` |
| 4 | Notifications implementation | `…/blob/main/lib/services/notification_service.dart` (UI: `…/lib/screens/settings/notifications_screen.dart`) |

---

## B. Screenshots to capture

### Auth
| Pts | File name | Screen / action | Must show |
|----|---|---|---|
| 6 | `signup_screen_evidence.png` | Open the **Sign Up** screen | 3 fields (username, email, password) + "Create Account" button + "Login" link |
| 2 | `signup_error.png` | On Sign Up, leave a field blank (or use a bad email) and tap Create Account | Red error banner visible |
| 5 | `login_screen_evidence.png` | Open the **Login** screen | email + password fields + "Login" button + "Sign Up" link |
| 2 | `login_error.png` | On Login, enter wrong credentials and tap Login | "Invalid email or password." error banner |

### Home & Detail
| Pts | File name | Screen / action | Must show |
|----|---|---|---|
| 4 | `home-screen-evidence.png` | **Home** screen after login | Habitt logo in the header + the habit list layout |
| 2 | `evidence-detail-navigation.png` | **Home** screen | The chevron / tap-to-open navigation icon on a habit row (the `>` arrow). Tip: a tap ripple on the row works too. |
| 2 | `evidence-detail-screen.png` | Tap a habit → **Detail** screen | Habit info: name, status, colour, reminder time |

### Local storage
| Pts | File name | Screen / action | Must show |
|----|---|---|---|
| 2 | `evidence-persistence.png` | Settings → Settings → **View Local Storage** | The raw key/value entries (e.g. `habitt_user`, `habitt_habits`) |
| 2 | `evidence-integrateScreen-persistence.png` | Split or two shots: **Home** (front-end data) + **View Local Storage** (same data) | The same habits visible both on screen and in storage |

### API
| Pts | File name | Screen / action | Must show |
|----|---|---|---|
| 2 | `evidence-api-ux.png` | Open the **Settings Menu** (menu icon on home) | The "Daily Quote" card populated with text fetched from the API |

### Settings
| Pts | File name | Screen / action | Must show |
|----|---|---|---|
| 2 | `evidence-menu-icon.png` | **Home** screen | The settings-menu (hamburger ☰) icon in the top-left of the app bar |
| 5 | `evidence-menu-items.png` | Tap the menu icon → **Settings Menu** | The menu items: Personal Info, Notifications, Settings (+ profile, Sign Out) |
| 2 | `evidence-settings-screen.png` | Settings Menu → **Settings** | The grouped Settings screen (Notifications / Appearance / Data / About) |

### Notifications
| Pts | File name | Screen / action | Must show |
|----|---|---|---|
| 2 | `evidence-notification-configure.png` | Settings Menu → **Notifications** | The reminder setup: "Enable All Reminders" toggle, time, per-habit list |
| 4 | `evidence-notification-alert.png` | On Notifications screen, tap **Send Test Notification** | The notification banner/heads-up appearing on the device |

---

## C. Final submission tips
1. Put all screenshots in the repo root (or an `/evidence` folder) and push.
2. Double-check every file name matches **exactly** (graders look for exact names).
3. Confirm the repo is **Public** before submitting the repo link.
4. After grading is done, **rotate the GitHub token** that was embedded in the
   original clone URL — it should not stay in the repo's git config.
