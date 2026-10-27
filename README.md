# MI DriveLab — SwiftUI starter

A native iPhone/iPad prototype for iOS 17 or later. No packages, account, or backend required.

## Run it

1. Open `MIDriveLab.xcodeproj` in Xcode.
2. Select the **MIDriveLab** scheme and an installed iPhone simulator in the toolbar.
3. Press **Command-R**.

To run on a real iPhone, choose your Apple development team under the target’s **Signing & Capabilities**, change `org.example.MIDriveLab` to your own unique bundle identifier, and select your connected device. Simulator builds do not require a signing team.

## Included

- **Learn:** RoadReady landing screen, four lessons with three handbook-based questions each, retry feedback, source page references, and saved question/lesson completion.
- **Practice:** Driving plan with Michigan GDL / Adult progress tracking, visual roadmap header, interactive "GDL explained" guide, next-step recommendations, 30h/50h/permit countdown progress bars, pinned prior hours journal entry, session logging by skill and day/night minutes, and swipe-to-delete.
- **Connect:** External Michigan resource links and a future mentor-program explanation.
- **Explore:** A small automotive-section placeholder inside Connect.
- System dark mode, native navigation, and scalable system text.

Question completion and practice entries use `@AppStorage` (UserDefaults) on the device. They persist across launches, but are not synced or an official licensing log. Deleting the app can remove this data. No location, contact information, or mentor profiles are collected. External links open websites with their own policies.

## Customize

Start in `MIDriveLab/MIDriveLabApp.swift` and `MIDriveLab/DrivingPlan.swift`:

- `MichiganRequirements`, `DrivingPlan`, and `RoadmapStep`: Michigan SOS requirement figures, roadmap steps for teens and adults, and questionnaire/settings views.
- `lessons` and `RoadQuestion`: lesson content, answer choices, explanations, and handbook references.
- `LearnView` and `LessonView`: lesson cards, question, and feedback.
- `PracticeView`, `DriveForm`, and `Drive`: journal, requirements progress, and persistence.
- `ConnectView`: resources and future features.

For the next version, split these into files, expand the handbook-based question bank and track practice progress by skill. Have educational content reviewed against current Michigan Secretary of State materials. The current lessons are not a complete driver-education course.

Volunteer matching is intentionally a future feature. Before implementing it, establish program partners, guardian involvement, eligibility and background checks, insurance arrangements, and safeguarding procedures. No real mentors or available programs are represented by the template.

## Demo walkthrough

1. Open Learn → any lesson. Try a wrong answer, then the correct answer. Each lesson has three questions based on the October 2025 handbook.
2. Answer all three correctly, then return to Learn to see the lesson marked completed. Relaunch to verify progress persists.
3. Open Practice and log a 30-minute session. Verify the total changes to 0.5 hours.
4. Relaunch the app to check persistence. Swipe left on the entry to delete it.
5. Open Connect to show the resource directory and planned community component.

Before submission, add an app icon, check the external links, and test on your target iPhone sizes with large text and dark mode.

## Lesson sources

The 12 practice questions are original paraphrases of *What Every Driver Must Know*, Michigan Department of State, October 2025 edition. Signs and signals reference pp. 30 and 50; Michigan Lefts p. 48; winter driving pp. 62–63; merging and roundabouts pp. 61 and 35. Each question displays its source section and printed page number, and each lesson links to the [official handbook](https://www.michigan.gov/sos/resources/forms/what-every-driver-must-know). The original stop-sign completion is preserved; the additional questions must be completed separately.


### AI tutor configuration

The tutor uses Firebase AI Logic through the Gemini Developer API. It does not need a private Gemini API key in the app or in a judge's Xcode settings. Keep the Firebase app configuration (`GoogleService-Info.plist`); the Firebase client API key identifies the project and is different from a private Gemini API key. Restrict that client key to the Firebase APIs it needs, not the Generative Language API.

In the Firebase console, enable the Gemini Developer API under AI Logic and ensure the project has available quota/credits. The last live test for this project reported depleted prepaid credits; migrating to the SDK does not change billing or restore credits.

If App Check is enforced, register the debug token for each judge's simulator during development. Release/device builds require the appropriate production App Check registration. Do not disable enforcement or distribute debug tokens publicly. A tested device build can avoid asking judges to configure their own simulator tokens.

A private Gemini key previously appeared in this repository. Revoke/replace it in Google AI Studio. Removing it from the current source does not remove it from earlier commits; share a clean source archive or remove the secret from history before publishing that history. Do not bypass GitHub's secret-scanning warning.
