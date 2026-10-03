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


# Cashify Clone - Development Documentation (Phase 2)

**Date:** October 3, 2026

This documentation covers all architecture updates, feature implementations, and environment configurations completed following the initial MVP foundation.

## 1. Environment & Project Migration

* **Multi-PC Development Setup:** Successfully migrated the codebase to a secondary development machine.
* **Firebase Configuration:** Retained the `firebase_options.dart` file during migration, allowing the new environment to instantly connect to the live cloud database without requiring a full Node.js/Firebase CLI reinstallation.
* **Git & Credential Management:** Established procedures for clearing cached Windows credentials and Android Studio Git settings to ensure clean repository access across machines.

## 2. Authentication & User Management

* **Real Firebase Authentication:** Replaced the simulated 1-second delay in `login_screen.dart` with live `FirebaseAuth` logic. The app now securely registers new users (`createUserWithEmailAndPassword`) and logs in existing users (`signInWithEmailAndPassword`).
* **App Routing Fix:** Updated `main.dart` to properly initialize with `LoginScreen()` as the root view instead of bypassing directly to the Home Screen.
* **Firebase Console Configuration:** Enabled the "Email/Password" sign-in provider within the Firebase Cloud Console to resolve `operation-not-allowed` security blocks.
* **User Profile & Logout (`profile_screen.dart`):**
* Created a dedicated Profile Screen accessible via the top-right person icon on the Home Screen.
* Displays the currently logged-in user's email address dynamically.
* Implemented a secure Firebase Logout function that clears the authentication token and navigates the user back to the Login Screen while clearing the routing history.



## 3. Pricing Engine & UX Flow Updates

* **The "Price Reveal" Screen (`price_quote_screen.dart`):** Built a dedicated intermediary screen to display the calculated value of the device in a large, clear format *before* the user is asked to input their home address.
* **Dynamic Price Calculation Refactor:** Updated the `ConditionQuestionnaireScreen` to perform price deductions internally prior to navigation.
* **Logic:** Base price is determined by model (e.g., iPhones = ₹45,000, Galaxy S = ₹35,000). Deductions are applied for dead devices (85% penalty), broken screens (-₹5,000), body dents (-₹2,500), and missing chargers (-₹1,000). Minimum salvage value is locked at ₹1,000.
* **Data Passing:** The calculated `finalPrice` is now passed directly into the Price Quote screen, resolving previous missing argument errors.


* **Flow Restructure:** The selling funnel is now finalized as: **Select Model ➔ Answer Questionnaire ➔ Price Reveal ➔ Enter Address ➔ Order Confirmed**.

## 4. Order Management Updates

* **Order Cancellation (`home_screen.dart`):**
* Added a "Cancel" button to the active orders list on the Home Screen.
* Implemented the `_cancelOrder` function, which triggers an `AlertDialog` for user confirmation to prevent accidental clicks.
* Wired the confirmation to execute a direct delete command to the Firestore database (`FirebaseFirestore.instance.collection('orders').doc(docId).delete()`), permanently removing the order from the cloud and instantly updating the UI.



---


* **Resolution:**
1. Replaced `.withOpacity(0.3)` with the modern `.withValues(alpha: 0.3)`.
2. Replaced `print()` with `debugPrint()`, which is automatically stripped out in release builds.
3. Safely ignored the spelling warning (or right-clicked to add it to the IDE's custom dictionary).
