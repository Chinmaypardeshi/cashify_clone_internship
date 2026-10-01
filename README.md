# Cashify Clone Development - Issue & Resolution Log

## 1. Environment Setup & Tooling

**Issue:** Git ownership errors and inability to launch emulators in Google Cloud Shell.

* **Root Cause:** Google Cloud Shell is a headless remote Linux server intended for cloud management, not local mobile UI development. It lacks a display server to render mobile emulators.
* **Resolution:** Abandoned Cloud Shell and transitioned to a local development environment. Installed Android Studio to acquire the underlying Android SDK and build tools, shifting all command-line operations to the local machine's terminal.

**Issue:** `flutter doctor --android-licenses` failed with a deprecation warning about `sdkmanager`.

* **Root Cause:** A known compatibility bug between Flutter and version `23.0` of the Android SDK Command-line Tools. The newer version removed the specific license-checking protocol Flutter relies on.
* **Resolution:** Opened Android Studio > SDK Manager > SDK Tools. Checked "Show Package Details", uninstalled version `23.0` of the Command-line Tools, and installed version `22.0`. Re-ran the command successfully.

**Issue:** Unable to run the Android Virtual Device (Emulator) due to missing WHPX (Windows Hypervisor Platform).

* **Root Cause:** The development machine is running Windows 7. WHPX was introduced in Windows 10 and is required for modern hardware-accelerated Android emulation.
* **Resolution:** Bypassed the Android Emulator entirely by leveraging Flutter's web compilation. Switched the target device to `Chrome (web)` and ran the app in the browser. Used Chrome Developer Tools (F12 > Device Toggle) to restrict the viewport to mobile dimensions for accurate UI testing.

## 2. Dependency Management

**Issue:** `Target of URI doesn't exist: 'package:firebase_auth/firebase_auth.dart'`.

* **Root Cause:** The project was created from scratch in Android Studio, meaning the required Firebase packages had not been declared in the `pubspec.yaml` configuration file.
* **Resolution:** Ran `flutter pub add firebase_core firebase_auth` in the terminal to automatically inject the dependencies into `pubspec.yaml`, followed by `flutter pub get` to download the packages and refresh the IDE cache.

## 3. Navigation & Routing

**Issue:** Tapping the Login button only printed "Login button pressed!" in the console without navigating to the new UI.

* **Root Cause:** Twofold issue: `main.dart` was hardcoded to display a temporary `LoginScreenPlaceholder` instead of the newly built `LoginScreen`, and the button itself lacked routing logic.
* **Resolution:** Updated `main.dart`'s `home` property to point to `LoginScreen()`. In `login_screen.dart`, replaced the dummy print statement with `Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));` to push the new screen onto the stack.

## 4. Code Linting & Best Practices

**Issue:** Editor highlighted warnings for `withOpacity`, `print`, and a typo for the word "Hinjawadi".

* **Root Cause:**
1. Flutter recently updated its color API to prevent precision loss, deprecating `.withOpacity()`.
2. Standard `print()` statements are flagged because they can leak sensitive data into system logs in production apps.
3. "Hinjawadi" is not recognized by the default IDE English dictionary.


* **Resolution:**
1. Replaced `.withOpacity(0.3)` with the modern `.withValues(alpha: 0.3)`.
2. Replaced `print()` with `debugPrint()`, which is automatically stripped out in release builds.
3. Safely ignored the spelling warning (or right-clicked to add it to the IDE's custom dictionary).