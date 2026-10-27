# MI DriveLab

MI DriveLab is a native iPhone and iPad app for iOS 17 or later that helps people study Michigan driving rules, track supervised practice, and connect with volunteer driving mentors.

## Run it

1. Open `MIDriveLab.xcodeproj` in Xcode.
2. Select the **MIDriveLab** scheme and an installed iPhone simulator.
3. Allow Xcode to download the Firebase package dependencies.
4. Press **Command-R**.

Running on a physical device requires Apple development signing.

Some features require an internet connection and a signed-in account.

## Included

### Learn

- Study Michigan driving rules through lessons and practice questions.
- Get explanations after answering questions.
- View handbook references for each question.
- Track completed questions and lessons.

### Practice

- Create a personalized driving plan for Michigan teen or adult licensing.
- Explore the licensing roadmap and requirements.
- Track daytime and nighttime practice minutes.
- Record multiple skills practiced during each drive.
- Include practice hours completed before using the app.
- View and delete saved practice entries.

### Mentors

- Browse available driving practice sessions.
- Volunteer to supervise a practice session.
- Offer practice in the learner’s car, the volunteer’s car, or either.
- Request a session as a learner.
- Accept or decline requests as a volunteer.
- Check the status of your sessions and requests.

The mentor feature does not include messaging.

### Resources

Explore Michigan driving resources and automotive information through summaries and links to external websites.

### AI tutor

The chatbot is connected through Firebase AI Logic. Its last live test was blocked by depleted Gemini API credits, so responses may remain unavailable until that is resolved.


## Suggested walkthrough

1. Open **Learn** and choose a lesson.
2. Select an incorrect answer to see the feedback, then try again.
3. Complete the lesson’s questions and return to check your progress.
4. Sign in and open **Practice**.
5. Log a drive with 20 daytime minutes and 10 nighttime minutes. Select the skills practiced and verify the entry appears in your journal.
6. Test **Mentors** with two accounts:
   - Use the volunteer account to post a session.
   - Use the learner account to request that session.
   - Return to the volunteer account to accept or decline the request.
   - Check the request status from the learner account.
7. Open **Resources** and explore an external link.
   
## Lesson sources

The practice questions are original paraphrases of *What Every Driver Must Know*, Michigan Department of State, October 2025 edition. Each question displays its source section and printed page number, and each lesson links to the [official handbook](https://www.michigan.gov/sos/resources/forms/what-every-driver-must-know). 
