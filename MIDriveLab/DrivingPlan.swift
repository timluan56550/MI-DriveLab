import SwiftUI

// MARK: - Michigan requirements

// Every Michigan requirement number lives here, in one place.
// If the state changes a rule, update it here and the whole app follows.
// Source: Michigan Department of State (SOS). Check these pages before each release.
enum MichiganRequirements {
    static let teenSourceURL = URL(
        string: "https://www.michigan.gov/sos/license-id/new-drivers-under-18"
    )!
    static let adultSourceURL = URL(
        string: "https://www.michigan.gov/sos/license-id/new-drivers-18-older"
    )!

    // Teens: needed before Segment 2
    static let segment2TotalHours = 30
    static let segment2NightHours = 2
    static let segment2PermitMonths = 3

    // Teens: needed before the driving skills test (and Level 2)
    static let skillsTestTotalHours = 50
    static let skillsTestNightHours = 10
    static let skillsTestPermitMonths = 6

    // Teens: driver education
    static let examPassingPercent = 70
    static let segment2ClassroomHours = 6
    static let segment1MinimumAge = "14 years and 8 months"
    static let level1MinimumAge = "14 years and 9 months"
    static let supervisorMinimumAge = 21

    // Teens: Level 2 restrictions
    static let level2NoDrivingHours = "10 p.m. to 5 a.m."
    static let level2MaxPassengers = 1

    // Adults (18 or older): hold the permit this many days before the skills test
    static let adultPermitDays = 30
}

// MARK: - Roadmap steps

// One step on the road to a license. Works like Lesson: plain data the screens can show.
struct RoadmapStep: Identifiable {
    let id: String
    let icon: String
    let title: String
    let summary: String
    let details: [String]
}

// Teens (under 18) follow Michigan's Graduated Driver Licensing (GDL) system.
let teenRoadmap = [
    RoadmapStep(
        id: "segment1",
        icon: "book",
        title: "Segment 1",
        summary: "Driver education: classroom and on-the-road training.",
        details: [
            "You must be at least \(MichiganRequirements.segment1MinimumAge) old to enroll.",
            "Taken through a state-certified driver education provider.",
            "Pass the Segment 1 state exam with at least \(MichiganRequirements.examPassingPercent)%.",
        ]
    ),
    RoadmapStep(
        id: "level1",
        icon: "person.2",
        title: "Level 1 Learner's License",
        summary: "Drive with a licensed supervising adult and keep a driving log.",
        details: [
            "You must be at least \(MichiganRequirements.level1MinimumAge) old.",
            "Drive only with a parent, guardian, or an adult age \(MichiganRequirements.supervisorMinimumAge) or older chosen by your parent or guardian.",
            "Your supervising driver must have a valid driver's license.",
            "Keep a driving log of your supervised practice.",
        ]
    ),
    RoadmapStep(
        id: "segment2",
        icon: "graduationcap",
        title: "Segment 2",
        summary: "At least \(MichiganRequirements.segment2ClassroomHours) hours of classroom instruction.",
        details: [
            "Before you start: log at least \(MichiganRequirements.segment2TotalHours) hours of supervised driving, including \(MichiganRequirements.segment2NightHours) at night.",
            "Before you start: hold your Level 1 License for at least \(MichiganRequirements.segment2PermitMonths) months in a row.",
            "Pass the Segment 2 state exam with at least \(MichiganRequirements.examPassingPercent)%.",
        ]
    ),
    RoadmapStep(
        id: "skillsTest",
        icon: "checkmark.seal",
        title: "Driving skills test",
        summary: "Pass the road test given by an independent testing business.",
        details: [
            "Before the test: log at least \(MichiganRequirements.skillsTestTotalHours) hours of supervised driving, including \(MichiganRequirements.skillsTestNightHours) at night.",
            "Before the test: hold your Level 1 License for at least \(MichiganRequirements.skillsTestPermitMonths) months.",
            "You must pass this test to get a Level 2 License.",
        ]
    ),
    RoadmapStep(
        id: "level2",
        icon: "car",
        title: "Level 2 Intermediate License",
        summary: "Drive on your own, with some limits.",
        details: [
            "No driving from \(MichiganRequirements.level2NoDrivingHours), except for allowed reasons.",
            "No more than \(MichiganRequirements.level2MaxPassengers) passenger under 21, except for allowed reasons.",
            "No cell phone use while driving, except in emergencies.",
        ]
    ),
    RoadmapStep(
        id: "level3",
        icon: "star",
        title: "Level 3 Full License",
        summary: "No GDL passenger or nighttime limits.",
        details: [
            "No supervision, passenger, or nighttime GDL limits.",
            "Parents and guardians are encouraged to keep helping you build skill.",
            "GDL ends when you turn 18.",
        ]
    ),
]

// Adults (18 or older) do not use GDL. They follow a shorter path.
let adultRoadmap = [
    RoadmapStep(
        id: "adultKnowledgeTest",
        icon: "doc.text",
        title: "Vision and knowledge tests",
        summary: "Study the handbook, then pass the vision and knowledge tests.",
        details: [
            "Study What Every Driver Must Know.",
            "Take the knowledge test at a Secretary of State office or online.",
            "Bring the documents the Secretary of State requires.",
        ]
    ),
    RoadmapStep(
        id: "adultPermit",
        icon: "person.2",
        title: "Temporary Instruction Permit",
        summary: "Practice with a licensed supervising adult.",
        details: [
            "Only drive with a licensed adult in the car.",
            "Hold your permit for at least \(MichiganRequirements.adultPermitDays) days before the skills test.",
            "An hours log is not required for adults, but it helps you track practice.",
        ]
    ),
    RoadmapStep(
        id: "adultSkillsTest",
        icon: "checkmark.seal",
        title: "Driving skills test",
        summary: "Pass the road test given by an independent testing business.",
        details: [
            "Schedule the test after your \(MichiganRequirements.adultPermitDays)-day permit period ends.",
        ]
    ),
    RoadmapStep(
        id: "adultLicense",
        icon: "star",
        title: "Driver's license",
        summary: "You're licensed. Keep practicing safe habits.",
        details: [
            "Keep learning, especially in winter weather and on new kinds of roads.",
        ]
    ),
]

// MARK: - My driving plan

// The answers a user gives about where they are in the licensing process.
// Codable lets Swift turn a plan into JSON text to save it, then read it back.
struct DrivingPlan: Codable {
    var isAdult = false
    var stageID = "segment1"
    var hasPermitDate = false
    var permitDate = Date()
    var priorDayMinutes = 0
    var priorNightMinutes = 0
    var completedSetup = false
    var dismissedAdultNote = false
    var updatedAt = Date()

    // The roadmap that matches the user's age group.
    var roadmap: [RoadmapStep] {
        if isAdult {
            return adultRoadmap
        } else {
            return teenRoadmap
        }
    }

    // The position of the current stage in the roadmap, starting at 0.
    var stageIndex: Int {
        for index in roadmap.indices {
            if roadmap[index].id == stageID {
                return index
            }
        }
        return 0
    }

    var currentStep: RoadmapStep {
        return roadmap[stageIndex]
    }
}

// MARK: - Saving and loading plans

// PlanStore keeps two copies of each user's plan:
// 1. A local copy on this device (UserDefaults), so the plan shows right away and works offline.
// 2. An online copy in Firebase at users/{userID}/plan, so the plan follows the account.
enum PlanStore {
    // Each user gets their own key, for example "drivingPlan-abc123".
    static func localKey(userID: String) -> String {
        return "drivingPlan-" + userID
    }

    static func loadLocalPlan(userID: String) -> DrivingPlan? {
        let savedText = UserDefaults.standard.string(forKey: localKey(userID: userID))
        if let savedText = savedText {
            let decoder = JSONDecoder()
            do {
                return try decoder.decode(DrivingPlan.self, from: Data(savedText.utf8))
            } catch {
                return nil
            }
        }
        return nil
    }

    static func saveLocalPlan(plan: DrivingPlan, userID: String) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(plan)
            let text = String(decoding: data, as: UTF8.self)
            UserDefaults.standard.set(text, forKey: localKey(userID: userID))
        } catch {
            return
        }
    }

    // The Firebase address for one user's plan. Writing to /plan leaves the name and email alone.
    static func onlineURL(user: FirebaseSignInResponse) -> URL? {
        let urlText =
            "\(FirebaseConfig.databaseURL)/users/\(user.localId)/plan.json?auth=\(user.idToken)"
        return URL(string: urlText)
    }

    static func loadOnlinePlan(user: FirebaseSignInResponse) async -> DrivingPlan? {
        guard let url = onlineURL(user: user) else {
            return nil
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            // If the user has no online plan yet, Firebase sends "null" and decoding fails.
            return try decoder.decode(DrivingPlan.self, from: data)
        } catch {
            return nil
        }
    }

    static func saveOnlinePlan(plan: DrivingPlan, user: FirebaseSignInResponse) async {
        guard let url = onlineURL(user: user) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(plan)
            let (_, _) = try await URLSession.shared.data(for: request)
        } catch {
            // The local copy is still saved, so nothing is lost if this fails.
            return
        }
    }
}

// MARK: - Setup questionnaire & Settings help information

enum PlanHelpInfo {
    static func stageAlertTitle(isAdult: Bool) -> String {
        return isAdult ? "Adult Licensing Stages" : "Michigan GDL Stages"
    }

    static func stageAlertMessage(isAdult: Bool) -> String {
        if isAdult {
            return "If you just started your journey, you are likely in the 'Vision and knowledge tests' stage.\n\nMichigan 18+ Timeline:\n1. Vision & knowledge test: Study handbook, pass test at SOS or online to get your TIP.\n2. Temporary Instruction Permit (TIP): Practice with a licensed adult 21+ for at least 30 days.\n3. Skills test: Take your road test after the 30-day wait.\n4. Driver's license: Full license issued."
        } else {
            return "If you just started your journey, you are likely in Segment 1!\n\nMichigan GDL Teen Timeline:\n1. Segment 1: Classroom and driving instruction (starting at age 14 yrs, 8 mos).\n2. Level 1 License: Supervised driving with a parent/guardian and driving log.\n3. Segment 2: Classroom course after logging 30 hours (2 night) and holding Level 1 for 3 months.\n4. Skills test: Driving test after logging 50 hours (10 night) and holding Level 1 for 6 months.\n5. Level 2: Intermediate license to drive independently with curfew/passenger limits.\n6. Level 3: Full license."
        }
    }

    static func permitAlertTitle(isAdult: Bool) -> String {
        return isAdult ? "Temporary Instruction Permit (TIP)" : "Level 1 Learner's License"
    }

    static func permitAlertMessage(isAdult: Bool) -> String {
        if isAdult {
            return "A Temporary Instruction Permit (TIP) is the paper permit issued by the Secretary of State after you pass the vision and written knowledge tests.\n\nIf you don't know what this is, you likely don't have it yet! Leave the toggle off. When you receive your TIP, enter the issue date printed on it so the app can track your mandatory 30-day practice countdown."
        } else {
            return "A Level 1 Learner's License is the paper permit issued by the Secretary of State after you pass Segment 1 and bring your certificate and documents to an SOS branch.\n\nIf you don't know what this is, you likely don't have it yet! Leave the toggle off. Once you receive your Level 1 license, enter the issue date printed on it to track your 3-month (Segment 2) and 6-month (Skills test) countdowns."
        }
    }
}

// MARK: - Setup questionnaire (after sign-up or from Practice)

struct PlanSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authentication: AuthenticationState

    @State private var isAdult = false
    @State private var stageID = "segment1"
    @State private var hasPermitDate = false
    @State private var permitDate = Date()
    @State private var priorDayHours = 0
    @State private var priorNightHours = 0
    @State private var showStageInfo = false
    @State private var showPermitInfo = false

    // Shows the stages that match the chosen age group.
    private var availableStages: [RoadmapStep] {
        if isAdult {
            return adultRoadmap
        } else {
            return teenRoadmap
        }
    }

    private func savePlan() {
        var updated = authentication.plan
        updated.isAdult = isAdult
        updated.stageID = stageID
        updated.hasPermitDate = hasPermitDate
        updated.permitDate = permitDate
        updated.priorDayMinutes = priorDayHours * 60
        updated.priorNightMinutes = priorNightHours * 60
        updated.completedSetup = true
        authentication.savePlan(updatedPlan: updated)
        dismiss()
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Personalize your Michigan driving roadmap and progress goals. You can change this anytime in settings.")
                        .foregroundStyle(.secondary)
                }

                Section("1. Your age group") {
                    Picker("Age group", selection: $isAdult) {
                        Text("Under 18 (Michigan GDL)").tag(false)
                        Text("18 or older (Adult track)").tag(true)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: isAdult) { _, newIsAdult in
                        // Reset the stage to the first step of the chosen track.
                        if newIsAdult {
                            stageID = adultRoadmap.first?.id ?? "adultKnowledgeTest"
                        } else {
                            stageID = teenRoadmap.first?.id ?? "segment1"
                        }
                    }
                }

                Section {
                    Picker("Where are you now?", selection: $stageID) {
                        ForEach(availableStages) { step in
                            Text(step.title).tag(step.id)
                        }
                    }
                } header: {
                    HStack {
                        Text("2. Current stage")
                        Spacer()
                        Button {
                            showStageInfo = true
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundStyle(.teal)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Stage help")
                    }
                }

                Section {
                    Toggle(
                        isAdult
                            ? "I have my Temporary Instruction Permit (TIP)"
                            : "I have my Level 1 Learner's License",
                        isOn: $hasPermitDate
                    )

                    if hasPermitDate {
                        DatePicker(
                            "Issue date",
                            selection: $permitDate,
                            in: ...Date(),
                            displayedComponents: .date
                        )
                    }
                } header: {
                    HStack {
                        Text("3. Permit date")
                        Spacer()
                        Button {
                            showPermitInfo = true
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundStyle(.teal)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Permit date help")
                    }
                }

                if isAdult == false {
                    Section("4. Prior practice hours") {
                        Text("If you practiced before using this app, enter your hours here so they count toward your Michigan requirements.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)

                        Stepper("Day hours: \(priorDayHours)", value: $priorDayHours, in: 0...100)
                        Stepper("Night hours: \(priorNightHours)", value: $priorNightHours, in: 0...50)
                    }
                }
            }
            .navigationTitle("My driving plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Skip") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save plan") {
                        savePlan()
                    }
                }
            }
            .alert(PlanHelpInfo.stageAlertTitle(isAdult: isAdult), isPresented: $showStageInfo) {
                Button("Got it", role: .cancel) { }
            } message: {
                Text(PlanHelpInfo.stageAlertMessage(isAdult: isAdult))
            }
            .alert(PlanHelpInfo.permitAlertTitle(isAdult: isAdult), isPresented: $showPermitInfo) {
                Button("Got it", role: .cancel) { }
            } message: {
                Text(PlanHelpInfo.permitAlertMessage(isAdult: isAdult))
            }
            .onAppear {
                // Pre-fill with any existing answers.
                let current = authentication.plan
                isAdult = current.isAdult
                stageID = current.stageID
                hasPermitDate = current.hasPermitDate
                permitDate = current.permitDate
                priorDayHours = current.priorDayMinutes / 60
                priorNightHours = current.priorNightMinutes / 60
            }
        }
    }
}

// MARK: - Plan settings

struct PlanSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authentication: AuthenticationState

    @State private var isAdult = false
    @State private var stageID = "segment1"
    @State private var hasPermitDate = false
    @State private var permitDate = Date()
    @State private var priorDayHours = 0
    @State private var priorNightHours = 0
    @State private var showTurned18Alert = false
    @State private var showStageInfo = false
    @State private var showPermitInfo = false

    private var availableStages: [RoadmapStep] {
        if isAdult {
            return adultRoadmap
        } else {
            return teenRoadmap
        }
    }

    private func savePlan() {
        var updated = authentication.plan
        updated.isAdult = isAdult
        updated.stageID = stageID
        updated.hasPermitDate = hasPermitDate
        updated.permitDate = permitDate
        updated.priorDayMinutes = priorDayHours * 60
        updated.priorNightMinutes = priorNightHours * 60
        updated.completedSetup = true
        authentication.savePlan(updatedPlan: updated)
        dismiss()
    }

    private func switchToAdult() {
        isAdult = true
        stageID = "adultPermit"
        hasPermitDate = false
        showTurned18Alert = true
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Age group", selection: $isAdult) {
                        Text("Under 18 (GDL)").tag(false)
                        Text("18 or older (Adult)").tag(true)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: isAdult) { _, newIsAdult in
                        if newIsAdult {
                            stageID = adultRoadmap.first?.id ?? "adultKnowledgeTest"
                        } else {
                            stageID = teenRoadmap.first?.id ?? "segment1"
                        }
                    }

                    Picker("Current stage", selection: $stageID) {
                        ForEach(availableStages) { step in
                            Text(step.title).tag(step.id)
                        }
                    }
                } header: {
                    HStack {
                        Text("Age group & stage")
                        Spacer()
                        Button {
                            showStageInfo = true
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundStyle(.teal)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Stage help")
                    }
                }

                if isAdult == false {
                    Section("Turned 18?") {
                        Button {
                            switchToAdult()
                        } label: {
                            Label("Turned 18? Update your plan", systemImage: "arrow.triangle.swap")
                        }
                        Text("Drivers 18 and older do not need to follow GDL or log 50 practice hours. Instead, Michigan requires a 30-day permit practice period.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                Section {
                    Toggle(
                        isAdult
                            ? "I have my Temporary Instruction Permit"
                            : "I have my Level 1 Learner's License",
                        isOn: $hasPermitDate
                    )

                    if hasPermitDate {
                        DatePicker(
                            "Issue date",
                            selection: $permitDate,
                            in: ...Date(),
                            displayedComponents: .date
                        )
                    }
                } header: {
                    HStack {
                        Text("Permit / License")
                        Spacer()
                        Button {
                            showPermitInfo = true
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundStyle(.teal)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Permit date help")
                    }
                }

                if isAdult == false {
                    Section("Prior practice hours") {
                        Stepper("Day hours: \(priorDayHours)", value: $priorDayHours, in: 0...100)
                        Stepper("Night hours: \(priorNightHours)", value: $priorNightHours, in: 0...50)
                        Text("These hours count toward your Segment 2 and skills test goals and appear as a pinned row in your practice journal.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Michigan SOS official source") {
                    if isAdult {
                        Link(
                            "SOS: First-time license 18 and older",
                            destination: MichiganRequirements.adultSourceURL
                        )
                    } else {
                        Link(
                            "SOS: New drivers under 18 (GDL)",
                            destination: MichiganRequirements.teenSourceURL
                        )
                    }
                }
            }
            .navigationTitle("Plan settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        savePlan()
                    }
                }
            }
            .alert("Switched to Adult Plan", isPresented: $showTurned18Alert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your plan is now set to the 18+ adult track. GDL hours requirements are no longer required. Be sure to enter your Temporary Instruction Permit date to track your 30-day countdown.")
            }
            .alert(PlanHelpInfo.stageAlertTitle(isAdult: isAdult), isPresented: $showStageInfo) {
                Button("Got it", role: .cancel) { }
            } message: {
                Text(PlanHelpInfo.stageAlertMessage(isAdult: isAdult))
            }
            .alert(PlanHelpInfo.permitAlertTitle(isAdult: isAdult), isPresented: $showPermitInfo) {
                Button("Got it", role: .cancel) { }
            } message: {
                Text(PlanHelpInfo.permitAlertMessage(isAdult: isAdult))
            }
            .onAppear {
                let current = authentication.plan
                isAdult = current.isAdult
                stageID = current.stageID
                hasPermitDate = current.hasPermitDate
                permitDate = current.permitDate
                priorDayHours = current.priorDayMinutes / 60
                priorNightHours = current.priorNightMinutes / 60
            }
        }
    }
}

// MARK: - GDL Explained (Step-by-step guide for Under 18)

struct GDLExplainedView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Intro header
                VStack(alignment: .leading, spacing: 10) {
                    Label("MICHIGAN SOS GUIDE", systemImage: "info.circle.fill")
                        .font(.caption.bold())
                        .foregroundStyle(.teal)

                    Text("Graduated Driver Licensing (GDL) Explained")
                        .font(.title2.bold())

                    Text("In Michigan, if you are under the age of 18 and wish to learn how to drive, you are required to complete driver education. Michigan's Graduated Driver Licensing system has two segments of driver education instruction (Segment 1 & Segment 2) and three licensing levels (Level 1 Learner's License, Level 2 Intermediate License, and Level 3 Full License). Driving privileges are increased under each licensing level as you gain confidence and skill. GDL ends for teens when they turn 18.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))

                Text("The GDL Steps")
                    .font(.headline)
                    .padding(.top, 4)

                // Step 1: Segment 1
                gdlSectionCard(
                    number: "1",
                    title: "Driver Education — Segment 1",
                    badge: "Age 14 yrs, 8 mos+",
                    content: "Consists of classroom instruction and on-the-road driver training through a state-certified driver education provider. A score of at least \(MichiganRequirements.examPassingPercent)% on the Segment 1 state exam is required to pass the course."
                )

                // Step 2: Level 1 License
                gdlSectionCard(
                    number: "2",
                    title: "Level 1 Learner's License",
                    badge: "Age 14 yrs, 9 mos+",
                    content: "Allows a teen to drive under the supervision of a parent, guardian, or adult age \(MichiganRequirements.supervisorMinimumAge) or older designated by the parent/guardian. The accompanying adult must hold a valid, unexpired driver's license."
                )

                // Step 3: Supervised Driving & The Driving Log
                gdlSectionCard(
                    number: "3",
                    title: "Supervised Driving & The Driving Log",
                    badge: "50 hours total (10 night)",
                    content: "Teens are required to keep a driving log and complete a minimum of \(MichiganRequirements.skillsTestTotalHours) hours of supervised driving (including \(MichiganRequirements.skillsTestNightHours) hours at nighttime) before they can take the driving skills test. Only a licensed parent, guardian, or designated driver age \(MichiganRequirements.supervisorMinimumAge) or older may coach a teen driver."
                )

                // Step 4: Segment 2
                gdlSectionCard(
                    number: "4",
                    title: "Driver Education — Segment 2",
                    badge: "30 hours logged + 3 months permit",
                    content: "Consists of a minimum of \(MichiganRequirements.segment2ClassroomHours) hours of classroom instruction. A score of at least \(MichiganRequirements.examPassingPercent)% on the Segment 2 state exam is required to pass. Teens must log at least \(MichiganRequirements.segment2TotalHours) hours of supervised driving time (including a minimum of \(MichiganRequirements.segment2NightHours) hours of nighttime driving) and have held their Level 1 License for at least \(MichiganRequirements.segment2PermitMonths) consecutive months before they can take Segment 2."
                )

                // Step 5: Driving Skills Test
                gdlSectionCard(
                    number: "5",
                    title: "Driving Skills Test",
                    badge: "Taken before Level 2",
                    content: "Must be passed before the Level 2 License can be issued. Driving skills tests are given by independent, state-approved driver testing businesses."
                )

                // Step 6: Level 2 Intermediate License
                gdlSectionCard(
                    number: "6",
                    title: "Level 2 Intermediate License",
                    badge: "Age 16+ · Independent driving",
                    content: "Allows teens to drive without supervision but places specific driving restrictions: teens cannot drive between \(MichiganRequirements.level2NoDrivingHours), may only have \(MichiganRequirements.level2MaxPassengers) passenger under 21 (unless for school/work exceptions), and cannot use a cell phone while driving except in emergencies."
                )

                // Step 7: Level 3 Full License
                gdlSectionCard(
                    number: "7",
                    title: "Level 3 Full License",
                    badge: "Age 17+ or 18",
                    content: "Allows teens to drive without supervision or passenger and nighttime restrictions. Parents and guardians are encouraged to continue to monitor their teen's driving."
                )

                // Parent hold / cancellation note
                VStack(alignment: .leading, spacing: 8) {
                    Label("Parent / Guardian Authority", systemImage: "exclamationmark.shield.fill")
                        .font(.headline)
                        .foregroundStyle(.orange)

                    Text("A parent or legal guardian can hold a teen at their current licensing level (GDL 1 or GDL 2) or cancel their GDL license at any time before their 18th birthday. To request a hold or cancellation of their teen's GDL license, the parent or legal guardian needs to schedule a visit at a Secretary of State office.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))

                Link(destination: MichiganRequirements.teenSourceURL) {
                    Label("Read official guidelines on Michigan.gov", systemImage: "arrow.up.right.square")
                        .font(.subheadline.bold())
                }
                .padding(.top, 4)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("GDL Explained")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func gdlSectionCard(number: String, title: String, badge: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(number)
                    .font(.headline.bold())
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .background(Color.teal, in: Circle())

                Text(title)
                    .font(.headline)

                Spacer()
            }

            Text(badge)
                .font(.caption.bold())
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.teal.opacity(0.15), in: Capsule())
                .foregroundStyle(.teal)

            Text(content)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - GDL Roadmap Detail View

struct GDLRoadmapView: View {
    @EnvironmentObject var authentication: AuthenticationState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                let plan = authentication.plan
                let steps = plan.roadmap

                Text(plan.isAdult ? "Adult Licensing Roadmap" : "Michigan GDL Roadmap")
                    .font(.title2.bold())

                Text(plan.isAdult
                     ? "Drivers 18 and older follow a simplified track with a 30-day practice permit."
                     : "Michigan Graduated Driver Licensing (GDL) guides teens through supervised practice and education.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                ForEach(steps.indices, id: \.self) { index in
                    let step = steps[index]
                    let isCurrent = (step.id == plan.stageID)
                    let isPast = (index < plan.stageIndex)

                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(isCurrent ? Color.teal : (isPast ? Color.teal.opacity(0.2) : Color(.systemGray5)))
                                    .frame(width: 38, height: 38)

                                if isPast {
                                    Image(systemName: "checkmark")
                                        .font(.subheadline.bold())
                                        .foregroundStyle(.teal)
                                } else {
                                    Image(systemName: step.icon)
                                        .font(.subheadline)
                                        .foregroundStyle(isCurrent ? .white : .secondary)
                                }
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(step.title)
                                        .font(.headline)
                                    if isCurrent {
                                        Text("Current")
                                            .font(.caption2.bold())
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.teal, in: Capsule())
                                            .foregroundStyle(.white)
                                    }
                                }
                                Text(step.summary)
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(step.details, id: \.self) { detail in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("•")
                                        .foregroundStyle(.teal)
                                    Text(detail)
                                        .font(.caption)
                                        .foregroundStyle(.primary)
                                }
                            }
                        }
                        .padding(.leading, 50)

                        if authentication.user != nil && isCurrent == false {
                            Button {
                                var updated = plan
                                updated.stageID = step.id
                                authentication.savePlan(updatedPlan: updated)
                            } label: {
                                Text("Set as my current stage")
                                    .font(.caption.bold())
                            }
                            .buttonStyle(.bordered)
                            .tint(.teal)
                            .padding(.leading, 50)
                            .padding(.top, 4)
                        }
                    }
                    .padding()
                    .background(
                        isCurrent
                            ? Color.teal.opacity(0.08)
                            : Color(.secondarySystemGroupedBackground),
                        in: RoundedRectangle(cornerRadius: 16)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isCurrent ? Color.teal : Color.clear, lineWidth: 1.5)
                    )
                }

                Link(
                    destination: plan.isAdult ? MichiganRequirements.adultSourceURL : MichiganRequirements.teenSourceURL
                ) {
                    Label("View requirements on Michigan SOS", systemImage: "arrow.up.right.square")
                        .font(.footnote.bold())
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Licensing Roadmap")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Practice View Subcomponents

// Compact header card at the top of Practice showing current stage and quick navigation to roadmap.
struct RoadmapHeaderCard: View {
    @EnvironmentObject var authentication: AuthenticationState

    var body: some View {
        let plan = authentication.plan
        let step = plan.currentStep
        let totalSteps = plan.roadmap.count
        let stepNumber = plan.stageIndex + 1

        NavigationLink {
            GDLRoadmapView()
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(plan.isAdult ? "MICHIGAN ADULT TRACK" : "MICHIGAN GDL ROADMAP")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text("Step \(stepNumber) of \(totalSteps)")
                        .font(.caption.bold())
                        .foregroundStyle(.teal)
                }

                HStack(alignment: .top, spacing: 14) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(step.title)
                            .font(.title2.bold())
                            .foregroundStyle(.primary)

                        Text(step.summary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }

                    Spacer()

                    Image(systemName: step.icon)
                        .font(.title)
                        .foregroundStyle(.teal)
                        .frame(width: 44, height: 44)
                }

                // Mini horizontal stage progress dots
                HStack(spacing: 6) {
                    ForEach(0..<totalSteps, id: \.self) { index in
                        Capsule()
                            .fill(index <= plan.stageIndex ? Color.teal : Color(.systemGray4))
                            .frame(height: 4)
                    }
                }
                .padding(.top, 4)
            }
            .padding(.vertical, 6)
        }
    }
}

// Explainer card for teens who have not yet completed their plan setup, or signed-out visitors.
struct GDLIntroCard: View {
    let onOpenSetup: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("ABOUT MICHIGAN GDL", systemImage: "sparkles")
                    .font(.caption.bold())
                    .foregroundStyle(.teal)
                Spacer()
            }

            Text("Under 18? Driver education is required in Michigan.")
                .font(.headline)

            Text("Michigan's Graduated Driver Licensing (GDL) has 2 segments of driver education and 3 licensing levels (Level 1 Learner's License, Level 2 Intermediate, Level 3 Full). Driving privileges increase as you gain skill. GDL ends when you turn 18.")
                .font(.footnote)
                .foregroundStyle(.secondary)

            HStack(spacing: 10) {
                NavigationLink {
                    GDLExplainedView()
                } label: {
                    Text("GDL explained")
                        .font(.subheadline.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.bordered)
                .tint(.teal)

                Button {
                    onOpenSetup()
                } label: {
                    Text("Set up plan")
                        .font(.subheadline.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .tint(.teal)
            }
        }
        .padding(.vertical, 4)
    }
}

// Dismissible tip for 18+ drivers to switch to adult plan.
struct AdultDismissibleNoteCard: View {
    let onSetupAdult: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "info.circle.fill")
                .foregroundStyle(.teal)
                .font(.title3)

            VStack(alignment: .leading, spacing: 4) {
                Text("18 or older?")
                    .font(.subheadline.bold())

                Text("Drivers 18+ do not need to log 50 hours under GDL. Set up your plan for the 30-day TIP countdown.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Button("Set up your plan…") {
                    onSetupAdult()
                }
                .font(.footnote.bold())
                .foregroundStyle(.teal)
                .padding(.top, 2)
            }

            Spacer()

            Button {
                onDismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                    .padding(6)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}

// Dynamic "Next Step" card based on stage and hours logged.
struct NextStepCard: View {
    let plan: DrivingPlan
    let totalHours: Double
    let nightHours: Double

    private func monthsFromPermit(months: Int) -> (daysRemaining: Int, targetDate: Date)? {
        guard plan.hasPermitDate else { return nil }
        guard let target = Calendar.current.date(byAdding: .month, value: months, to: plan.permitDate) else { return nil }
        let days = Calendar.current.dateComponents([.day], from: Date(), to: target).day ?? 0
        return (max(0, days), target)
    }

    private func adultPermitDaysRemaining() -> Int? {
        guard plan.hasPermitDate else { return nil }
        let daysPassed = Calendar.current.dateComponents([.day], from: plan.permitDate, to: Date()).day ?? 0
        return max(0, MichiganRequirements.adultPermitDays - daysPassed)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("YOUR NEXT GOAL")
                .font(.caption.bold())
                .foregroundStyle(.secondary)

            if plan.isAdult {
                adultNextGoal
            } else {
                teenNextGoal
            }
        }
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var adultNextGoal: some View {
        switch plan.stageID {
        case "adultKnowledgeTest":
            Text("Pass knowledge & vision tests")
                .font(.title2.bold())
            Text("Study What Every Driver Must Know, then take the test at an SOS branch or online to receive your Temporary Instruction Permit (TIP).")
                .font(.subheadline)
                .foregroundStyle(.secondary)

        case "adultPermit":
            if let daysLeft = adultPermitDaysRemaining() {
                if daysLeft > 0 {
                    Text("\(daysLeft) days left on permit wait")
                        .font(.title2.bold())
                    Text("Michigan requires holding your TIP for \(MichiganRequirements.adultPermitDays) days before taking your skills test. Practice with a licensed adult 21+.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    Text("Permit waiting period complete!")
                        .font(.title2.bold())
                        .foregroundStyle(.teal)
                    Text("You have held your TIP for 30+ days. You are eligible to take your road driving skills test.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            } else {
                Text("Practice with a licensed adult 21+")
                    .font(.title2.bold())
                Text("Enter your TIP issue date in settings to track your mandatory \(MichiganRequirements.adultPermitDays)-day countdown.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

        case "adultSkillsTest":
            Text("Schedule your driving skills test")
                .font(.title2.bold())
            Text("Driving skills tests are administered by independent, state-approved test businesses.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

        default:
            Text("Full driver's license")
                .font(.title2.bold())
            Text("Congratulations on earning your Michigan driver's license! Continue practicing safe driving.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var teenNextGoal: some View {
        switch plan.stageID {
        case "segment1":
            Text("Complete Segment 1 driver education")
                .font(.title2.bold())
            Text("Enroll at age \(MichiganRequirements.segment1MinimumAge) or older. Pass the state exam with at least \(MichiganRequirements.examPassingPercent)% to qualify for a Level 1 License.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

        case "level1":
            let neededTotal = max(0.0, Double(MichiganRequirements.segment2TotalHours) - totalHours)
            let neededNight = max(0.0, Double(MichiganRequirements.segment2NightHours) - nightHours)

            if neededTotal > 0 || neededNight > 0 {
                Text(String(format: "%.1f more hours (%.1f night) until Segment 2", neededTotal, neededNight))
                    .font(.title2.bold())
            } else {
                Text("Practice hours complete for Segment 2!")
                    .font(.title2.bold())
                    .foregroundStyle(.teal)
            }

            if let info = monthsFromPermit(months: MichiganRequirements.segment2PermitMonths) {
                if info.daysRemaining > 0 {
                    Text("\(info.daysRemaining) days left on 3-month Level 1 requirement (eligible \(info.targetDate.formatted(date: .abbreviated, time: .omitted))).")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    Text("3-month permit requirement met for Segment 2.")
                        .font(.subheadline)
                        .foregroundStyle(.teal)
                }
            }

        case "segment2", "skillsTest":
            let neededTotal = max(0.0, Double(MichiganRequirements.skillsTestTotalHours) - totalHours)
            let neededNight = max(0.0, Double(MichiganRequirements.skillsTestNightHours) - nightHours)

            if neededTotal > 0 || neededNight > 0 {
                Text(String(format: "%.1f more hours (%.1f night) until skills test", neededTotal, neededNight))
                    .font(.title2.bold())
            } else {
                Text("50 hours reached for driving skills test!")
                    .font(.title2.bold())
                    .foregroundStyle(.teal)
            }

            if let info = monthsFromPermit(months: MichiganRequirements.skillsTestPermitMonths) {
                if info.daysRemaining > 0 {
                    Text("\(info.daysRemaining) days left on 6-month permit requirement (eligible \(info.targetDate.formatted(date: .abbreviated, time: .omitted))).")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    Text("6-month permit requirement met for skills test.")
                        .font(.subheadline)
                        .foregroundStyle(.teal)
                }
            }

        case "level2":
            Text("Level 2 Intermediate License")
                .font(.title2.bold())
            Text("Drive independently! Remember: no driving from \(MichiganRequirements.level2NoDrivingHours), max \(MichiganRequirements.level2MaxPassengers) passenger under 21, and no cell phone use.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

        default:
            Text("Level 3 Full License")
                .font(.title2.bold())
            Text("All GDL restrictions lifted. GDL officially ends when you turn 18.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

// Progress bars for practice hours and permit countdowns.
struct RequirementsProgressCard: View {
    let plan: DrivingPlan
    let totalHours: Double
    let nightHours: Double

    private func permitDaysProgress(totalDays: Int) -> (passed: Int, total: Int, fraction: Double)? {
        guard plan.hasPermitDate else { return nil }
        let passed = Calendar.current.dateComponents([.day], from: plan.permitDate, to: Date()).day ?? 0
        let clampedPassed = min(totalDays, max(0, passed))
        return (clampedPassed, totalDays, Double(clampedPassed) / Double(totalDays))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("STATE REQUIREMENTS")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)

                Text("Requirements progress")
                    .font(.title2.bold())
            }

            if plan.isAdult {
                adultProgress
            } else {
                teenProgress
            }
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private var adultProgress: some View {
        if let progress = permitDaysProgress(totalDays: MichiganRequirements.adultPermitDays) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("30-day TIP practice period")
                        .font(.subheadline)
                    Spacer()
                    Text("\(progress.passed) / \(progress.total) days")
                        .font(.subheadline.bold())
                        .foregroundStyle(.teal)
                }
                ProgressView(value: progress.fraction)
                    .tint(.teal)
            }
        } else {
            HStack {
                Text("Temporary Instruction Permit")
                    .font(.subheadline)
                Spacer()
                Text("Add date in settings")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }

        Text("No practice hour log is legally required for drivers 18 and older. You can still use the journal below to track personal driving practice.")
            .font(.footnote)
            .foregroundStyle(.secondary)
    }

    @ViewBuilder
    private var teenProgress: some View {
        // Goal 1: Segment 2 (30h total / 2h night)
        VStack(alignment: .leading, spacing: 10) {
            Text("Goal 1: Before Segment 2")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)

            progressBar(
                title: "Total hours",
                current: totalHours,
                goal: Double(MichiganRequirements.segment2TotalHours),
                unit: "h"
            )

            progressBar(
                title: "Night hours",
                current: nightHours,
                goal: Double(MichiganRequirements.segment2NightHours),
                unit: "h"
            )

            if let progress = permitDaysProgress(totalDays: 90) {
                progressBar(
                    title: "3-month Level 1 wait",
                    current: Double(progress.passed),
                    goal: Double(progress.total),
                    unit: "days"
                )
            }
        }

        Divider()

        // Goal 2: Skills test & Level 2 (50h total / 10h night + 6 month wait)
        VStack(alignment: .leading, spacing: 10) {
            Text("Goal 2: Before skills test (Level 2)")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)

            progressBar(
                title: "Total hours",
                current: totalHours,
                goal: Double(MichiganRequirements.skillsTestTotalHours),
                unit: "h"
            )

            progressBar(
                title: "Night hours",
                current: nightHours,
                goal: Double(MichiganRequirements.skillsTestNightHours),
                unit: "h"
            )

            if let progress = permitDaysProgress(totalDays: 180) {
                progressBar(
                    title: "6-month permit countdown",
                    current: Double(progress.passed),
                    goal: Double(progress.total),
                    unit: "days"
                )
            } else if plan.hasPermitDate == false {
                HStack {
                    Text("6-month permit countdown")
                        .font(.footnote)
                    Spacer()
                    Text("Add permit date in settings")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func progressBar(title: String, current: Double, goal: Double, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.footnote)
                Spacer()
                Text(String(format: "%.1f / %.0f %@", min(current, goal), goal, unit))
                    .font(.footnote.bold())
                    .foregroundStyle(.teal)
            }
            ProgressView(value: min(1.0, current / max(1.0, goal)))
                .tint(.teal)
        }
    }
}
