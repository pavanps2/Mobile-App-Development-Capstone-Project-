# Habitt — User Stories

These nine user stories define the scope of the **Habitt** mobile habit-tracking
application. Each story follows the standard *"As a … I want … so that …"*
format and includes acceptance criteria.

---

## 1. User Registration (Sign Up)
**As a** new user
**I want** to create an account with a username, email, and password
**so that** I can have my own personal habit-tracking profile.

**Acceptance criteria**
- The sign-up screen has three fields: username, email, and password.
- A "Create Account" button submits the form.
- Empty fields, an invalid email, or a password under 6 characters show an error.
- On success the user is taken to the home screen and the account is saved locally.

---

## 2. User Login
**As a** returning user
**I want** to log in with my email and password
**so that** I can access my saved habits.

**Acceptance criteria**
- The login screen has two fields: email and password.
- A "Login" button submits the credentials.
- Invalid credentials display a clear login error message.
- A "Sign Up" link navigates to the registration screen.

---

## 3. View Habits on the Home Screen
**As a** logged-in user
**I want** to see all my habits on a home dashboard
**so that** I can quickly review what I need to do today.

**Acceptance criteria**
- The home screen shows the app logo in the header.
- Habits are grouped into "To-Do" and "Done" sections.
- Each habit shows its name and an accent colour.
- Habits load from local storage when the app opens.

---

## 4. Add a New Habit
**As a** user
**I want** to add a new habit with a name and colour
**so that** I can start tracking a new routine.

**Acceptance criteria**
- A floating "+" button opens the "Add New Habit" form.
- I can enter a habit name and pick an accent colour.
- Saving adds the habit to the To-Do list and persists it.

---

## 5. View Habit Details
**As a** user
**I want** to tap a habit to open its detail screen
**so that** I can see and edit its full information.

**Acceptance criteria**
- Tapping a habit on the home screen navigates to a detail screen.
- The detail screen shows the habit name, colour, status, and reminder time.
- I can edit the name, mark it done/to-do, and delete the habit.

---

## 6. Mark a Habit as Complete
**As a** user
**I want** to mark a habit as completed
**so that** I can track my daily progress.

**Acceptance criteria**
- Tapping a habit's circle toggles it between To-Do and Done.
- Completed habits move to the "Done" section with a strike-through.
- The completion state is saved in local storage.

---

## 7. Persist Data Locally
**As a** user
**I want** my account, habits, and settings to be saved on my device
**so that** my data is still there after I close and reopen the app.

**Acceptance criteria**
- Account, habits, and settings are stored with SharedPreferences.
- Data is reloaded automatically on app start.
- A "View Local Storage" screen lets me inspect the persisted data.

---

## 8. See a Daily Motivational Quote (External API)
**As a** user
**I want** to see a motivational quote fetched from an external API
**so that** I stay inspired to keep my habits.

**Acceptance criteria**
- The app fetches a quote from a public quotes API over HTTPS.
- The quote and its author are displayed in the settings menu / settings screen.
- A loading indicator shows while fetching and an error message shows on failure.

---

## 9. Configure Notification Reminders
**As a** user
**I want** to enable reminders and receive notifications for my habits
**so that** I don't forget to complete them.

**Acceptance criteria**
- A settings menu icon opens the settings menu.
- The settings and notifications screens let me enable reminders and set a time.
- I can toggle a reminder per habit.
- A "Send Test Notification" button triggers a local notification immediately.
