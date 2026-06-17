# Habitt — Setup & Run Guide

This repo contains the **Flutter source** for the Habitt habit-tracking app
(the `lib/` folder, `pubspec.yaml`, assets and docs). The native platform
folders (`android/`, `ios/`) are **not** committed — they are generated for
your machine so the Gradle/Xcode versions match your local Flutter SDK.

Follow these steps once to get a runnable project.

## 1. Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.x or newer
  (run `flutter doctor` and resolve any issues)
- An Android emulator / device, or iOS simulator (macOS)

## 2. Generate the native platform folders
From the project root:

```bash
flutter create . --platforms=android,ios --project-name habitt
```

This adds the `android/` and `ios/` folders **without** touching the existing
`lib/` code.

## 3. Install dependencies
```bash
flutter pub get
```

## 4. Enable notification permissions (Android)
Open `android/app/src/main/AndroidManifest.xml` and add these lines just
**inside** the `<manifest>` tag (above `<application>`):

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.VIBRATE"/>
```

The exact block to paste is in [`android_manifest_snippet.xml`](android_manifest_snippet.xml).

> The `flutter_local_notifications` plugin also requires
> `compileSdkVersion 34` and `minSdkVersion 21` (the defaults from
> `flutter create` already satisfy this).

## 5. Run the app
```bash
flutter run
```

## 6. Capturing screenshots
With the app running on an emulator, use:

```bash
flutter screenshot --out=screenshot.png
```

…or the emulator's built-in camera button. See
[`SCREENSHOT_CHECKLIST.md`](SCREENSHOT_CHECKLIST.md) for the exact file name
and content required for every graded screenshot.
