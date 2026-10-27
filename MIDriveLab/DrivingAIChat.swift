import SwiftUI
import FirebaseAI

struct ChatMessage: Identifiable {
    let id = UUID()
    let isUser: Bool
    let text: String
}

@MainActor
class DrivingAIChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isLoading = false

    private let relatedQuestion: RoadQuestion?
    private let chat: Chat

    init(question: RoadQuestion? = nil) {
        relatedQuestion = question

        // Firebase handles Gemini authorization; no private Gemini key is bundled here.
        let ai = FirebaseAI.firebaseAI(backend: .googleAI())
        let model = ai.generativeModel(
            modelName: "gemini-3.8-flash",
            generationConfig: GenerationConfig(temperature: 0.3),
            systemInstruction: ModelContent(role: "system", parts: """
            You are a friendly, encouraging Michigan driver's education tutor helping teen drivers learn to drive safely.
            Keep explanations concise (2–4 sentences), clear, and age-appropriate. Answer only questions about driving, vehicles, or road safety.
            Use supplied lesson explanations as reference material. You do not have the full Michigan handbook. Do not invent quotations, page numbers, or claim to have verified rules against it. When unsure, direct the learner to What Every Driver Must Know or their instructor.
            """)
        )
        chat = model.startChat()

        if let question = question {
            messages.append(ChatMessage(
                isUser: false,
                text: "I see you're looking at question: \"\(question.prompt)\". What would you like help understanding?"
            ))
        } else {
            messages.append(ChatMessage(
                isUser: false,
                text: "Hi! I'm your Michigan driving assistant. Ask me anything about road signs, right-of-way, or Michigan driving laws!"
            ))
        }
    }

    func sendMessage(_ text: String) async {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !isLoading else { return }

        messages.append(ChatMessage(isUser: true, text: trimmed))
        isLoading = true
        defer { isLoading = false }

        var prompt = trimmed
        if let question = relatedQuestion {
            // Include the lesson on follow-ups too, including after a failed request.
            prompt = """
            [Lesson reference: \(question.source)]
            Question: \(question.prompt)
            Correct answer: \(question.options[question.correctAnswer])
            Explanation: \(question.explanation)
            Student query: \(trimmed)
            """
        }

        do {
            // The SDK keeps the successful conversation history for this chat.
            let response = try await chat.sendMessage(prompt)
            if let reply = response.text,
               !reply.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                messages.append(ChatMessage(isUser: false, text: reply))
            } else {
                messages.append(ChatMessage(isUser: false, text: "The tutor couldn't answer that message. Try rephrasing your question about driving."))
            }
        } catch {
            messages.append(ChatMessage(isUser: false, text: errorMessage(for: error)))
        }
    }

    private func errorMessage(for error: Error) -> String {
        // Inspect service errors without printing credentials or request contents.
        let details = String(reflecting: error).lowercased()
        if details.contains("prepayment") || details.contains("credits are depleted") {
            return "The AI tutor is unavailable because the app's Gemini API credits have run out. The app owner needs to update billing in Google AI Studio. You can still use the lesson explanations."
        }
        if details.contains("quota") || details.contains("resource_exhausted") {
            return "The AI tutor has reached its usage limit. Please try again later. You can still use the lesson explanations."
        }
        if details.contains("appcheck") || details.contains("app check") || details.contains("permission_denied") {
            return "The AI tutor couldn't verify this app. The app owner needs to check Firebase AI Logic and App Check setup."
        }
        return "Sorry, I couldn't reach the driving assistant right now. Please check your internet connection and try again."
    }
}

// MARK: - Driving AI Chat Sheet

struct DrivingAIChatSheet: View {
    @StateObject var viewModel: DrivingAIChatViewModel
    @State private var inputText = ""
    @Environment(\.dismiss) private var dismiss

    private let suggestions = [
        "What is a Michigan Left?",
        "How many night hours do I need?",
        "How do roundabouts work in Michigan?"
    ]

    init(question: RoadQuestion? = nil) {
        _viewModel = StateObject(wrappedValue: DrivingAIChatViewModel(question: question))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.messages) { message in
                                messageBubble(for: message)
                                    .id(message.id)
                            }

                            if viewModel.isLoading {
                                HStack {
                                    ProgressView()
                                    Text("Driving coach is thinking...")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .id("loadingIndicator")
                            }
                        }
                        .padding()
                    }
                    .onChange(of: viewModel.messages.count) {
                        if let lastMessage = viewModel.messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }

                // Quick suggestion chips when chat has just started
                if viewModel.messages.count <= 2 && !viewModel.isLoading {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(suggestions, id: \.self) { suggestion in
                                Button {
                                    Task {
                                        await viewModel.sendMessage(suggestion)
                                    }
                                } label: {
                                    Text(suggestion)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.teal.opacity(0.12), in: Capsule())
                                        .foregroundStyle(.teal)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                    }
                }

                Divider()

                HStack(spacing: 12) {
                    TextField("Ask a driving question...", text: $inputText)
                        .textFieldStyle(.roundedBorder)

                    Button {
                        let textToSend = inputText
                        inputText = ""
                        Task {
                            await viewModel.sendMessage(textToSend)
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .font(.title3)
                            .foregroundStyle(inputText.isEmpty ? Color.secondary : Color.teal)
                    }
                    .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty || viewModel.isLoading)
                }
                .padding(.horizontal)
                .padding(.top, 12)

                Text("AI can make mistakes. Always verify rules in What Every Driver Must Know.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 8)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Road Assistant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func messageBubble(for message: ChatMessage) -> some View {
        HStack {
            if message.isUser {
                Spacer(minLength: 40)
                Text(message.text)
                    .padding(12)
                    .background(Color.teal)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                Text(message.text)
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .foregroundStyle(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                Spacer(minLength: 40)
            }
        }
    }
}
