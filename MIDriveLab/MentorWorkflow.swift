import SwiftUI

// MARK: - Session and request helpers

extension PracticeSession {
    var isOpen: Bool {
        return cancelledAt == nil && completedAt == nil && acceptedLearnerID == nil && startTime > Date()
    }

    var statusTitle: String {
        if cancelledAt != nil { return "Cancelled" }
        if completedAt != nil { return "Completed" }
        if acceptedLearnerID != nil { return "Booked" }
        if startTime <= Date() { return "Past session" }
        return "Available"
    }
}

extension PracticeRequest {
    // Figures out the current status of a request based on the session it belongs to.
    func resolvedStatus(session: PracticeSession?) -> RequestStatus {
        if status != .pending && status != .accepted {
            return status
        }
        guard let session = session else {
            return .sessionUnavailable
        }
        if let accepted = session.acceptedLearnerID, accepted != learnerID {
            return .sessionUnavailable
        }
        if session.cancelledAt != nil {
            return .sessionCancelled
        }
        if session.acceptedLearnerID == learnerID {
            if session.completedAt == nil {
                return .accepted
            } else {
                return .completed
            }
        }
        if session.startTime <= Date() {
            return .sessionExpired
        }
        return status
    }
}

func practiceCarTitle(_ option: CarOption) -> String {
    switch option {
    case .learnersCar:
        return "Learner’s car"
    case .volunteersCar:
        return "Volunteer’s car"
    case .eitherCar:
        return "Learner’s or volunteer’s car"
    }
}

// MARK: - Auto-logging completed mentor sessions into Practice journal

func autoLogCompletedMentorSession(session: PracticeSession, learnerID: String) {
    let defaults = UserDefaults.standard
    let stored = defaults.string(forKey: "practiceLogs") ?? "[]"
    let decoder = JSONDecoder()
    var drives = (try? decoder.decode([Drive].self, from: Data(stored.utf8))) ?? []

    // Prevent duplicate entries for this session
    if drives.contains(where: { $0.id == session.id }) {
        return
    }

    let totalMinutes = max(15, Int(session.endTime.timeIntervalSince(session.startTime) / 60))
    let hour = Calendar.current.component(.hour, from: session.startTime)
    let isNight = hour >= 21 || hour < 6 || session.skills.contains(where: { $0.localizedCaseInsensitiveContains("night") })
    let dayMin = isNight ? 0 : totalMinutes
    let nightMin = isNight ? totalMinutes : 0

    var newDrive = Drive(
        date: session.startTime,
        dayMinutes: dayMin,
        nightMinutes: nightMin,
        skills: session.skills.isEmpty ? ["General driving"] : session.skills
    )
    newDrive.id = session.id
    newDrive.userID = learnerID

    drives.insert(newDrive, at: 0)

    let encoder = JSONEncoder()
    if let data = try? encoder.encode(drives), let jsonStr = String(data: data, encoding: .utf8) {
        defaults.set(jsonStr, forKey: "practiceLogs")
    }
}

// MARK: - Mentor store (Firebase Realtime Database)

@MainActor
class MentorStore: ObservableObject {
    @Published var sessions: [PracticeSession] = []
    @Published var myRequests: [PracticeRequest] = []
    @Published var sessionRequests: [UUID: [PracticeRequest]] = [:]
    @Published var busy = false
    @Published var error = ""
    @Published var message = ""

    private let confirmedVolunteerKey = "confirmedVolunteerSessions"

    func markVolunteerCompleted(_ sessionID: UUID) {
        var ids = (UserDefaults.standard.string(forKey: confirmedVolunteerKey) ?? "")
            .components(separatedBy: ",")
            .filter { $0.isEmpty == false }
        if ids.contains(sessionID.uuidString) == false {
            ids.append(sessionID.uuidString)
            UserDefaults.standard.set(ids.joined(separator: ","), forKey: confirmedVolunteerKey)
        }
    }

    func isVolunteerCompleted(_ sessionID: UUID) -> Bool {
        let ids = (UserDefaults.standard.string(forKey: confirmedVolunteerKey) ?? "")
            .components(separatedBy: ",")
        return ids.contains(sessionID.uuidString)
    }

    func requestStatus(_ request: PracticeRequest) -> RequestStatus {
        let matchingSession = sessions.first(where: { $0.id == request.sessionID })
        return request.resolvedStatus(session: matchingSession)
    }

    // Builds a Firebase URL with the user's auth token.
    private func databaseURL(path: String, user: FirebaseSignInResponse) -> URL? {
        let urlText = "\(FirebaseConfig.databaseURL)/\(path).json?auth=\(user.idToken)"
        return URL(string: urlText)
    }

    // Loads all sessions from Firebase.
    private func fetchSessions(user: FirebaseSignInResponse) async -> [PracticeSession] {
        guard let url = databaseURL(path: "sessions", user: user) else {
            return []
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            if let dict = try? decoder.decode([String: PracticeSession].self, from: data) {
                var list = Array(dict.values)
                list.sort { $0.startTime < $1.startTime }
                return list
            }
        } catch {
            return []
        }
        return []
    }

    // Loads all requests for one specific session (used by the volunteer).
    private func fetchRequestsForSession(sessionID: UUID, user: FirebaseSignInResponse) async -> [PracticeRequest] {
        let path = "sessionRequests/\(sessionID.uuidString)"
        guard let url = databaseURL(path: path, user: user) else {
            return []
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            if let dict = try? decoder.decode([String: PracticeRequest].self, from: data) {
                var list = Array(dict.values)
                list.sort { ($0.createdAt ?? .distantPast) < ($1.createdAt ?? .distantPast) }
                return list
            }
        } catch {
            return []
        }
        return []
    }

    // Loads all requests sent by the signed-in learner.
    private func fetchMyRequests(user: FirebaseSignInResponse) async -> [PracticeRequest] {
        let indexPath = "requestsByLearner/\(user.localId)"
        guard let indexURL = databaseURL(path: indexPath, user: user) else {
            return []
        }
        var result: [PracticeRequest] = []
        do {
            let (data, _) = try await URLSession.shared.data(from: indexURL)
            let decoder = JSONDecoder()
            if let indexDict = try? decoder.decode([String: Bool].self, from: data) {
                for sessionKey in indexDict.keys.sorted() {
                    let requestPath = "sessionRequests/\(sessionKey)/\(user.localId)"
                    if let reqURL = databaseURL(path: requestPath, user: user),
                       let (reqData, _) = try? await URLSession.shared.data(from: reqURL),
                       let record = try? decoder.decode(PracticeRequest.self, from: reqData) {
                        result.append(record)
                    }
                }
            }
        } catch {
            return []
        }
        result.sort { ($0.createdAt ?? .distantPast) > ($1.createdAt ?? .distantPast) }
        return result
    }

    // Sends a PUT request to save data at a Firebase path.
    private func putJSON(data: Data, path: String, user: FirebaseSignInResponse) async -> Bool {
        guard let url = databaseURL(path: path, user: user) else {
            return false
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                return httpResponse.statusCode >= 200 && httpResponse.statusCode < 300
            }
        } catch {
            return false
        }
        return false
    }

    // Reloads sessions and requests from Firebase.
    func refresh(auth: AuthenticationState) async {
        guard let user = auth.user else {
            sessions = []
            myRequests = []
            sessionRequests = [:]
            return
        }
        if busy { return }
        busy = true
        error = ""

        var allSessions = await fetchSessions(user: user)
        for index in allSessions.indices {
            if allSessions[index].completedAt == nil && isVolunteerCompleted(allSessions[index].id) {
                allSessions[index].completedAt = Date()
            }
        }

        let learnerRequests = await fetchMyRequests(user: user)
        var incoming: [UUID: [PracticeRequest]] = [:]
        for session in allSessions {
            if session.volunteerID == user.localId {
                incoming[session.id] = await fetchRequestsForSession(sessionID: session.id, user: user)
            }
        }

        sessions = allSessions
        myRequests = learnerRequests
        sessionRequests = incoming

        // Automatically log any completed sessions for this learner into their Practice journal.
        for request in learnerRequests {
            if let session = allSessions.first(where: { $0.id == request.sessionID }),
               session.completedAt != nil && (session.acceptedLearnerID == user.localId || request.status == .accepted) {
                autoLogCompletedMentorSession(session: session, learnerID: user.localId)
            }
        }

        busy = false
    }

    func loadRequests(session: PracticeSession, auth: AuthenticationState) async {
        await refresh(auth: auth)
    }

    // Saves a new or edited volunteer session to Firebase.
    func save(session: PracticeSession, auth: AuthenticationState) async throws {
        guard let user = auth.user else {
            error = "Please sign in first."
            return
        }
        busy = true
        error = ""
        message = ""

        var cleanSession = session
        cleanSession.area = session.area.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanSession.skills = Array(Set(session.skills)).sorted()

        let encoder = JSONEncoder()
        if let data = try? encoder.encode(cleanSession) {
            let success = await putJSON(data: data, path: "sessions/\(cleanSession.id.uuidString)", user: user)
            busy = false
            if success {
                message = "Session saved online."
                await refresh(auth: auth)
            } else {
                error = "Could not save session. Check your connection and try again."
            }
        } else {
            busy = false
        }
    }

    // Submits a learner's request to join a practice session.
    func submit(session: PracticeSession, text: String, car: CarOption, auth: AuthenticationState) async throws {
        guard let user = auth.user else {
            error = "Please sign in first."
            return
        }
        busy = true
        error = ""
        message = ""

        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let chosenCar = session.carOption == .eitherCar ? car : session.carOption

        var newRequest = PracticeRequest(
            sessionID: session.id,
            learnerID: user.localId,
            volunteerID: session.volunteerID,
            message: trimmedText,
            carOption: chosenCar
        )
        newRequest.learnerName = auth.fullName.isEmpty ? "Learner" : auth.fullName
        newRequest.sessionArea = session.area
        newRequest.sessionStartTime = session.startTime
        newRequest.sessionEndTime = session.endTime
        newRequest.createdAt = Date()

        // Save the session ID in the learner's request list first, then save the request details.
        _ = await putJSON(
            data: Data("true".utf8),
            path: "requestsByLearner/\(user.localId)/\(session.id.uuidString)",
            user: user
        )

        let encoder = JSONEncoder()
        if let data = try? encoder.encode(newRequest) {
            let path = "sessionRequests/\(session.id.uuidString)/\(user.localId)"
            let success = await putJSON(data: data, path: path, user: user)
            busy = false
            if success {
                message = "Request sent to the volunteer."
                await refresh(auth: auth)
            } else {
                error = "Could not send request. Please try again."
            }
        } else {
            busy = false
        }
    }

    // Volunteer accepts or declines a learner's request.
    func decide(_ request: PracticeRequest, accept: Bool, auth: AuthenticationState) async {
        guard let user = auth.user else { return }
        busy = true
        error = ""
        message = ""
        let encoder = JSONEncoder()

        if accept {
            if var session = sessions.first(where: { $0.id == request.sessionID }) {
                session.acceptedLearnerID = request.learnerID
                if let data = try? encoder.encode(session) {
                    _ = await putJSON(data: data, path: "sessions/\(session.id.uuidString)", user: user)
                    message = "Request accepted. Other pending requests are now unavailable."
                }
            }
        } else {
            var updatedRequest = request
            updatedRequest.status = .declined
            if let data = try? encoder.encode(updatedRequest) {
                let path = "sessionRequests/\(request.sessionID.uuidString)/\(request.learnerID)"
                _ = await putJSON(data: data, path: path, user: user)
                message = "Request declined."
            }
        }

        busy = false
        await refresh(auth: auth)
    }

    // Learner withdraws their pending request.
    func withdraw(_ request: PracticeRequest, auth: AuthenticationState) async {
        guard let user = auth.user else { return }
        busy = true
        error = ""
        message = ""

        var updatedRequest = request
        updatedRequest.status = .withdrawn
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(updatedRequest) {
            let path = "sessionRequests/\(request.sessionID.uuidString)/\(request.learnerID)"
            _ = await putJSON(data: data, path: path, user: user)
            message = "Request withdrawn."
        }

        busy = false
        await refresh(auth: auth)
    }

    // Volunteer marks a session completed or cancelled.
    func close(_ session: PracticeSession, complete: Bool, auth: AuthenticationState) async {
        guard let user = auth.user else { return }
        busy = true
        error = ""
        message = ""

        var updatedSession = session
        let encoder = JSONEncoder()

        if complete {
            updatedSession.completedAt = Date()
            if updatedSession.endTime <= Date(), let data = try? encoder.encode(updatedSession) {
                _ = await putJSON(data: data, path: "sessions/\(session.id.uuidString)", user: user)
            }
            markVolunteerCompleted(session.id)
            if let learnerID = session.acceptedLearnerID {
                autoLogCompletedMentorSession(session: session, learnerID: learnerID)
            }
            message = "Session marked completed."
        } else {
            updatedSession.cancelledAt = Date()
            if let data = try? encoder.encode(updatedSession) {
                _ = await putJSON(data: data, path: "sessions/\(session.id.uuidString)", user: user)
            }
            message = "Session cancelled. Learners will see the updated status."
        }

        busy = false
        await refresh(auth: auth)
    }
}

// MARK: - Reusable screen pieces

struct MentorFeedback: View {
    @EnvironmentObject var mentors: MentorStore
    var body: some View {
        if mentors.busy { ProgressView("Updating…") }
        if !mentors.error.isEmpty { Text(mentors.error).foregroundStyle(.red).font(.subheadline) }
        if !mentors.message.isEmpty { Text(mentors.message).foregroundStyle(.secondary).font(.subheadline) }
    }
}

struct MentorSignInPrompt: View {
    var message = "Sign in to find or offer driving practice."
    @State private var showSignIn = false
    @State private var showCreateAccount = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Start with an account", systemImage: "person.crop.circle")
                .font(.title2.bold())
                .foregroundStyle(.teal)
            Text(message)
                .foregroundStyle(.secondary)

            Button {
                showSignIn = true
            } label: {
                Label("Sign in", systemImage: "person.crop.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)

            Button {
                showCreateAccount = true
            } label: {
                Label("Create account", systemImage: "person.badge.plus")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.bordered)
        }
        .tint(.teal)
        .navigationDestination(isPresented: $showSignIn) {
            SignInView()
        }
        .navigationDestination(isPresented: $showCreateAccount) {
            SignUpView()
        }
    }
}

// Reuse the same account card when an action requires sign-in.
struct AccountPromptSheet: View {
    let message: String
    @EnvironmentObject var authentication: AuthenticationState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if authentication.user == nil {
                        MentorSignInPrompt(message: message)
                    } else {
                        Label("You’re signed in", systemImage: "checkmark.circle.fill")
                            .font(.title2.bold())
                            .foregroundStyle(.teal)
                        Button("Continue") { dismiss() }
                            .buttonStyle(.borderedProminent)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18))
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Your account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .tint(.teal)
        }
    }
}

struct MentorSessionInfo: View {
    let session: PracticeSession
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(session.statusTitle.uppercased())
                    .font(.caption2.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(statusColor(for: session).opacity(0.15), in: Capsule())
                    .foregroundStyle(statusColor(for: session))
                Spacer()
            }
            Label(session.area, systemImage: "mappin.and.ellipse").font(.headline)
            Text("Volunteer: " + session.volunteerName)
            Text(session.startTime.formatted(date: .abbreviated, time: .shortened))
            Text("Ends: " + session.endTime.formatted(date: .abbreviated, time: .shortened))
            Text("Skills: " + session.skills.joined(separator: ", "))
            Label(practiceCarTitle(session.carOption), systemImage: "car.fill")
            if !session.notes.isEmpty { Text(session.notes).foregroundStyle(.secondary) }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func statusColor(for session: PracticeSession) -> Color {
        if session.cancelledAt != nil { return .red }
        if session.completedAt != nil { return .green }
        if session.acceptedLearnerID != nil { return .teal }
        if session.startTime <= Date() { return .secondary }
        return .blue
    }
}

struct MentorRequestInfo: View {
    let request: PracticeRequest
    let status: RequestStatus
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(status.title.uppercased())
                    .font(.caption2.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(requestStatusColor(status).opacity(0.15), in: Capsule())
                    .foregroundStyle(requestStatusColor(status))
                Spacer()
            }
            if let area = request.sessionArea { Text(area).font(.headline) }
            if let date = request.sessionStartTime { Text(date.formatted(date: .abbreviated, time: .shortened)) }
            Text("Learner: " + (request.learnerName ?? "Learner"))
            Text(request.message)
            Text("Car: " + practiceCarTitle(request.carOption)).font(.subheadline)
        }
    }

    private func requestStatusColor(_ status: RequestStatus) -> Color {
        switch status {
        case .accepted: return .teal
        case .completed: return .green
        case .pending: return .blue
        case .declined, .withdrawn, .sessionCancelled, .sessionExpired, .sessionUnavailable: return .secondary
        }
    }
}

// MARK: - Learner browsing and requests

struct LearnerView: View {
    @EnvironmentObject var authentication: AuthenticationState
    @EnvironmentObject var mentors: MentorStore

    private var available: [PracticeSession] {
        mentors.sessions.filter { $0.isOpen && $0.volunteerID != authentication.user?.localId }
    }

    var body: some View {
        List {
            Section {
                Text("Find driving practice").font(.title2.bold())
                Text("Browse sessions offered by volunteers. Refresh to see the latest availability.")
                    .foregroundStyle(.secondary)
                NavigationLink { MyRequestsView() } label: { Label("My requests", systemImage: "tray") }
                MentorFeedback()
            }
            if authentication.user == nil {
                Section { MentorSignInPrompt() }
            } else if available.isEmpty && !mentors.busy && mentors.error.isEmpty {
                ContentUnavailableView("No sessions available", systemImage: "calendar",
                    description: Text("Check back later. Your own sessions are managed on the Mentors screen."))
            } else {
                ForEach(available) { session in
                    NavigationLink { SessionDetailView(session: session) } label: {
                        MentorSessionInfo(session: session)
                    }.buttonStyle(.plain)
                }
            }
        }
        .navigationTitle("Find practice")
        .navigationBarTitleDisplayMode(.inline)
        .tint(.teal)
        .toolbar {
            Button {
                Task { await mentors.refresh(auth: authentication) }
            } label: {
                Label("Refresh", systemImage: "arrow.clockwise")
            }
            .disabled(mentors.busy || authentication.user == nil)
        }
        .refreshable { await mentors.refresh(auth: authentication) }
        .task(id: authentication.user?.localId) { await mentors.refresh(auth: authentication) }
    }
}

struct SessionDetailView: View {
    let session: PracticeSession
    @EnvironmentObject var authentication: AuthenticationState
    @EnvironmentObject var mentors: MentorStore
    private var current: PracticeSession? { mentors.sessions.first { $0.id == session.id } }

    var body: some View {
        List {
            if let current {
                Section { MentorSessionInfo(session: current) }
                Section {
                    if current.isOpen && current.volunteerID != authentication.user?.localId {
                        NavigationLink("Request this session") { RequestSessionView(session: current) }
                    } else {
                        Text("This session is not available for a new request.")
                    }
                }
            } else {
                Text("This session is no longer available. Refresh the session list.")
            }
            Section { MentorFeedback() }
        }
        .navigationTitle("Session details")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable { await mentors.refresh(auth: authentication) }
    }
}

struct RequestSessionView: View {
    let session: PracticeSession
    @EnvironmentObject var authentication: AuthenticationState
    @EnvironmentObject var mentors: MentorStore
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCar: CarOption = .learnersCar
    @State private var message = ""
    @State private var isSubmitting = false
    @State private var feedback = ""

    @MainActor
    private func submit() async {
        guard !isSubmitting else { return }
        isSubmitting = true
        feedback = ""
        do {
            try await mentors.submit(session: session, text: message, car: selectedCar, auth: authentication)
            isSubmitting = false
            dismiss()
        } catch {
            feedback = error.localizedDescription
            isSubmitting = false
        }
    }

    var body: some View {
        Form {
            Section("Session") { MentorSessionInfo(session: session) }
            Section("What would you like to practice?") {
                TextField("Tell the volunteer about your practice goals", text: $message, axis: .vertical)
                Text("\(message.count)/2,000 characters").font(.caption).foregroundStyle(.secondary)
            }
            Section("Car for this session") {
                if session.carOption == .eitherCar {
                    Picker("Choose a car", selection: $selectedCar) {
                        Text("My car").tag(CarOption.learnersCar)
                        Text("Volunteer’s car").tag(CarOption.volunteersCar)
                    }
                } else {
                    Text(practiceCarTitle(session.carOption))
                }
            }
            Section {
                Button("Send request") { Task { await submit() } }
                    .disabled(isSubmitting || mentors.busy || authentication.user == nil ||
                        message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || message.count > 2000)
                if isSubmitting { ProgressView("Sending request…") }
                if !feedback.isEmpty { Text(feedback).foregroundStyle(.red) }
            }
        }
        .navigationTitle("Request practice")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MyRequestsView: View {
    @EnvironmentObject var authentication: AuthenticationState
    @EnvironmentObject var mentors: MentorStore
    @AppStorage("confirmedLearnerSessions") private var confirmedLearnerSessionsText = ""

    private func isLearnerConfirmed(_ sessionID: UUID) -> Bool {
        let ids = confirmedLearnerSessionsText.components(separatedBy: ",")
        return ids.contains(sessionID.uuidString)
    }

    private func confirmSessionAsLearner(request: PracticeRequest) {
        var ids = confirmedLearnerSessionsText.components(separatedBy: ",").filter { !$0.isEmpty }
        if !ids.contains(request.sessionID.uuidString) {
            ids.append(request.sessionID.uuidString)
            confirmedLearnerSessionsText = ids.joined(separator: ",")
        }

        let matchingSession = mentors.sessions.first(where: { $0.id == request.sessionID })
        let sessionToLog: PracticeSession
        if let matchingSession {
            sessionToLog = matchingSession
        } else {
            var s = PracticeSession(
                startTime: request.sessionStartTime ?? Date(),
                endTime: request.sessionEndTime ?? Date().addingTimeInterval(3600),
                area: request.sessionArea ?? "Practice area",
                skills: ["General driving"],
                notes: request.message,
                carOption: request.carOption
            )
            s.id = request.sessionID
            sessionToLog = s
        }
        autoLogCompletedMentorSession(session: sessionToLog, learnerID: authentication.user?.localId ?? request.learnerID)
    }

    var body: some View {
        List {
            Section { MentorFeedback() }
            if authentication.user == nil {
                Section { MentorSignInPrompt() }
            } else {
                if mentors.myRequests.isEmpty && !mentors.busy && mentors.error.isEmpty {
                    ContentUnavailableView("No requests yet", systemImage: "tray",
                        description: Text("Browse sessions to request supervised practice."))
                }
                ForEach(mentors.myRequests) { request in
                    Section {
                        let status = mentors.requestStatus(request)
                        MentorRequestInfo(request: request, status: status)
                        if status == .pending {
                            Button("Withdraw request", role: .destructive) {
                                Task { await mentors.withdraw(request, auth: authentication) }
                            }.disabled(mentors.busy)
                        } else if status == .accepted || status == .completed {
                            let learnerConfirmed = isLearnerConfirmed(request.sessionID)
                            let volunteerConfirmed = (status == .completed)

                            if learnerConfirmed && volunteerConfirmed {
                                Label("Both parties confirmed completed", systemImage: "checkmark.seal.fill")
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.green)
                                Text("Practice drive has been automatically added to your Practice journal.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            } else if learnerConfirmed && !volunteerConfirmed {
                                Label("Confirmed by you · Waiting for mentor", systemImage: "clock.badge.checkmark.fill")
                                    .font(.subheadline)
                                    .foregroundStyle(.teal)
                                Text("Drive recorded in your journal. Status will update to completed when mentor confirms.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            } else if !learnerConfirmed && volunteerConfirmed {
                                VStack(alignment: .leading, spacing: 6) {
                                    Label("Mentor confirmed drive completed!", systemImage: "exclamationmark.circle.fill")
                                        .font(.subheadline.bold())
                                        .foregroundStyle(.teal)
                                    Text("Confirm below to complete two-party verification and record the hours in your journal.")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Button("Confirm completion & log hours") {
                                        confirmSessionAsLearner(request: request)
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                            } else {
                                Button("Confirm drive completed") {
                                    confirmSessionAsLearner(request: request)
                                }
                                .buttonStyle(.bordered)
                                .disabled(mentors.busy)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("My requests")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                Task { await mentors.refresh(auth: authentication) }
            } label: {
                Label("Refresh", systemImage: "arrow.clockwise")
            }
            .disabled(mentors.busy || authentication.user == nil)
        }
        .refreshable { await mentors.refresh(auth: authentication) }
        .task(id: authentication.user?.localId) { await mentors.refresh(auth: authentication) }
    }
}

// MARK: - Volunteer request management

struct SessionRequestsView: View {
    let session: PracticeSession
    @EnvironmentObject var authentication: AuthenticationState
    @EnvironmentObject var mentors: MentorStore
    @State private var selectedRequest: PracticeRequest?
    @State private var showAcceptance = false
    private var current: PracticeSession? { mentors.sessions.first { $0.id == session.id } }
    private var requests: [PracticeRequest] { mentors.sessionRequests[session.id] ?? [] }

    var body: some View {
        List {
            Section { MentorFeedback() }
            if authentication.user?.localId != session.volunteerID {
                Text("Only this session’s volunteer can review requests.")
            } else {
                if let current { Section { MentorSessionInfo(session: current) } }
                if requests.isEmpty && !mentors.busy && mentors.error.isEmpty {
                    ContentUnavailableView("No requests yet", systemImage: "tray")
                }
                ForEach(requests) { request in
                    Section {
                        let status = mentors.requestStatus(request)
                        MentorRequestInfo(request: request, status: status)
                        if status == .pending && current?.isOpen == true {
                            Button("Accept request") {
                                selectedRequest = request
                                showAcceptance = true
                            }
                            .disabled(mentors.busy)
                            Button("Decline request", role: .destructive) {
                                Task { await mentors.decide(request, accept: false, auth: authentication) }
                            }
                            .disabled(mentors.busy)
                        } else if status == .accepted, let current {
                            Button("Mark session complete") {
                                Task { await mentors.close(current, complete: true, auth: authentication) }
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(mentors.busy)
                        } else if status == .completed {
                            Label("Drive completed and logged in journal", systemImage: "checkmark.seal.fill")
                                .font(.subheadline.bold())
                                .foregroundStyle(.green)
                        }
                    }
                }
            }
        }
        .navigationTitle("Session requests")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                Task { await mentors.loadRequests(session: session, auth: authentication) }
            } label: {
                Label("Refresh", systemImage: "arrow.clockwise")
            }
            .disabled(mentors.busy)
        }
        .refreshable { await mentors.loadRequests(session: session, auth: authentication) }
        .task(id: authentication.user?.localId) { await mentors.loadRequests(session: session, auth: authentication) }
        .alert("Accept this request?", isPresented: $showAcceptance) {
            Button("Accept") {
                if let request = selectedRequest {
                    Task { await mentors.decide(request, accept: true, auth: authentication) }
                }
                selectedRequest = nil
            }
            Button("Keep pending", role: .cancel) { selectedRequest = nil }
        } message: {
            Text("This books the session for this learner. Other pending requests will become unavailable.")
        }
    }
}

struct MentorsView: View {
    @EnvironmentObject var authentication: AuthenticationState
    @EnvironmentObject var mentors: MentorStore
    @State private var selectedSession: PracticeSession?
    @State private var showCancellation = false

    private var mine: [PracticeSession] {
        mentors.sessions.filter { $0.volunteerID == authentication.user?.localId }
    }

    private var activeSessions: [PracticeSession] {
        mine.filter { $0.cancelledAt == nil && $0.completedAt == nil }
    }

    private var pastSessions: [PracticeSession] {
        mine.filter { $0.cancelledAt != nil || $0.completedAt != nil }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    introduction

                    VStack(spacing: 0) {
                        NavigationLink {
                            LearnerView()
                        } label: {
                            navigationRow(title: "Find practice sessions",
                                subtitle: "Explore practice offered by volunteers.", icon: "magnifyingglass")
                        }
                        .buttonStyle(.plain)
                        Divider().padding(.horizontal, 20)
                        NavigationLink {
                            MyRequestsView()
                        } label: {
                            navigationRow(title: "My requests",
                                subtitle: "Check your requests and booking history.", icon: "tray")
                        }
                        .buttonStyle(.plain)
                    }
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18))

                    if mentors.busy || !mentors.error.isEmpty || !mentors.message.isEmpty {
                        VStack(alignment: .leading, spacing: 10) { MentorFeedback() }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18))
                    }

                    if authentication.user == nil {
                        MentorSignInPrompt()
                            .padding(20)
                            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18))
                    } else {
                        NavigationLink {
                            PostSessionView { session in
                                try await mentors.save(session: session, auth: authentication)
                            }
                        } label: {
                            Label("Post a session", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(mentors.busy)

                        Text("My offered sessions").font(.title2.bold())
                        if activeSessions.isEmpty && !mentors.busy {
                            VStack(alignment: .leading, spacing: 12) {
                                Label("Your first session starts here", systemImage: "calendar.badge.plus")
                                    .font(.headline)
                                    .foregroundStyle(.teal)
                                Text("Post a session to offer your time and help a learner build confidence.")
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18))
                        }
                        ForEach(activeSessions) { session in
                            sessionCard(session)
                                .padding(20)
                                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18))
                        }

                        if !pastSessions.isEmpty {
                            Text("History").font(.title2.bold())
                            ForEach(pastSessions) { session in
                                sessionCard(session)
                                    .padding(20)
                                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18))
                            }
                        }
                    }

                    Text("Pilot notice: A full rollout requires program partners, guardian involvement, volunteer screening, and insurance review.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Mentors")
            .tint(.teal)
            .toolbar {
                Button {
                    Task { await mentors.refresh(auth: authentication) }
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
                .disabled(mentors.busy || authentication.user == nil)
            }
            .refreshable { await mentors.refresh(auth: authentication) }
            .task(id: authentication.user?.localId) { await mentors.refresh(auth: authentication) }
            .alert("Cancel this session?", isPresented: $showCancellation) {
                Button("Cancel session", role: .destructive) {
                    if let session = selectedSession {
                        Task { await mentors.close(session, complete: false, auth: authentication) }
                    }
                    selectedSession = nil
                }
                Button("Keep session", role: .cancel) { selectedSession = nil }
            } message: {
                Text("The session stays in history. Pending and accepted learners will see that it was cancelled when they refresh.")
            }
        }
    }

    private var introduction: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("COMMUNITY DRIVING MENTORS", systemImage: "person.2.fill")
                .font(.caption.bold())
            Text("More practice.\nMore confidence.")
                .font(.largeTitle.bold())
            Text("Find supervised practice or offer a session using your car, the learner’s car, or either.")
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .foregroundStyle(.white)
        .background(Color(red: 0.04, green: 0.27, blue: 0.29), in: RoundedRectangle(cornerRadius: 24))
    }

    private func navigationRow(title: String, subtitle: String, icon: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon).font(.title2).foregroundStyle(.teal).frame(width: 32)
            VStack(alignment: .leading, spacing: 5) {
                Text(title).font(.headline).foregroundStyle(.primary)
                Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right").foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .contentShape(Rectangle())
    }

    @ViewBuilder
    private func sessionCard(_ session: PracticeSession) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            MentorSessionInfo(session: session)
            Divider()

            if session.completedAt != nil {
                Label("Drive completed and logged in journal", systemImage: "checkmark.seal.fill")
                    .font(.subheadline.bold())
                    .foregroundStyle(.green)
            } else if session.cancelledAt != nil {
                Label("Session cancelled", systemImage: "xmark.circle")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            NavigationLink("View requests (\((mentors.sessionRequests[session.id] ?? []).count))") {
                SessionRequestsView(session: session)
            }
            .buttonStyle(.bordered)
            if session.isOpen && (mentors.sessionRequests[session.id] ?? []).isEmpty {
                NavigationLink("Edit session") {
                    PostSessionView(existingSession: session) { updated in
                        try await mentors.save(session: updated, auth: authentication)
                    }
                }
                .buttonStyle(.bordered)
                .disabled(mentors.busy)
                Text("Once a request arrives, cancel and repost to change the arrangements.")
                    .font(.caption).foregroundStyle(.secondary)
            }
            if session.cancelledAt == nil && session.completedAt == nil {
                if session.acceptedLearnerID != nil {
                    Button("Mark session complete") {
                        Task { await mentors.close(session, complete: true, auth: authentication) }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(mentors.busy)
                }
                Button("Cancel session", role: .destructive) {
                    selectedSession = session
                    showCancellation = true
                }
                .buttonStyle(.borderless)
                .disabled(mentors.busy)
            }
        }
    }
}

typealias VolunteerView = MentorsView
