# Habitt — Mobile Habit Tracking App

Habitt is a cross-platform mobile app built with **Flutter** that helps users
build and track daily habits. It was created for the Mobile App Development
capstone project.

| | |
|---|---|
| **Framework** | Flutter / Dart |
| **State** | `ChangeNotifier` |
| **Local storage** | `shared_preferences` |
| **External API** | `http` → [DummyJSON Quotes](https://dummyjson.com/quotes) |
| **Notifications** | `flutter_local_notifications` |

## Features

- ✅ **Sign Up** with username, email & password (with validation + error states)
- ✅ **Login** with email & password (with login error handling)
- ✅ **Home screen** with branded header, To-Do / Done habit lists
- ✅ **Detail screen** showing full information for a selected habit
- ✅ **Local storage** persistence (account, habits, settings)
- ✅ **External API integration** — daily motivational quote
- ✅ **Settings menu** + **Settings screen**
- ✅ **Notifications** — daily reminders & test notifications

## Project structure

```
lib/
├── main.dart                       # App entry, init & routing
├── models/
│   ├── user.dart                   # User model
│   └── habit.dart                  # Habit model
├── services/
│   ├── auth_service.dart           # Sign-up & login logic ─► AUTH
│   ├── storage_service.dart        # SharedPreferences  ─► LOCAL STORAGE
│   ├── api_service.dart            # HTTP quote fetch   ─► API INTEGRATION
│   └── notification_service.dart   # Local notifications ─► NOTIFICATIONS
├── state/
│   └── app_state.dart              # In-memory habit store
├── theme/
│   └── app_theme.dart              # Colours & theme
├── widgets/
│   ├── app_logo.dart               # Brand logo (home header)
│   └── form_helpers.dart           # Shared field label + error banner
└── screens/
    ├── auth/
    │   ├── login_screen.dart       # ─► LOGIN screen
    │   └── signup_screen.dart      # ─► SIGN-UP screen
    ├── home/
    │   ├── home_screen.dart        # ─► HOME screen
    │   └── add_habit_sheet.dart    # Add-habit form
    ├── detail/
    │   └── detail_screen.dart      # ─► DETAIL screen
    └── settings/
        ├── settings_menu_screen.dart   # ─► SETTINGS MENU
        ├── settings_screen.dart        # ─► SETTINGS screen
        ├── notifications_screen.dart   # ─► NOTIFICATIONS screen
        └── storage_debug_screen.dart   # Local-storage inspector
```

## Mapping to the capstone deliverables

| Deliverable | File |
|---|---|
| User stories | [`USER_STORIES.md`](USER_STORIES.md) |
| Sign-up implementation | [`lib/screens/auth/signup_screen.dart`](lib/screens/auth/signup_screen.dart) + [`lib/services/auth_service.dart`](lib/services/auth_service.dart) |
| Login implementation | [`lib/screens/auth/login_screen.dart`](lib/screens/auth/login_screen.dart) + [`lib/services/auth_service.dart`](lib/services/auth_service.dart) |
| Home screen | [`lib/screens/home/home_screen.dart`](lib/screens/home/home_screen.dart) |
| Detail screen | [`lib/screens/detail/detail_screen.dart`](lib/screens/detail/detail_screen.dart) |
| Local storage | [`lib/services/storage_service.dart`](lib/services/storage_service.dart) |
| API integration | [`lib/services/api_service.dart`](lib/services/api_service.dart) |
| Settings menu | [`lib/screens/settings/settings_menu_screen.dart`](lib/screens/settings/settings_menu_screen.dart) |
| Settings screen | [`lib/screens/settings/settings_screen.dart`](lib/screens/settings/settings_screen.dart) |
| Notifications | [`lib/services/notification_service.dart`](lib/services/notification_service.dart) + [`lib/screens/settings/notifications_screen.dart`](lib/screens/settings/notifications_screen.dart) |

## Getting started

```bash
flutter pub get
flutter run
```
