import Foundation

// Identifiable gives each question its own ID so SwiftUI can display it in a list.
struct RoadQuestion: Identifiable {
    let id: String
    let prompt: String
    let options: [String]
    // Answer positions start at 0. The first choice is 0, and the second is 1, and so on.
    let correctAnswer: Int
    let explanation: String
    let source: String
}

struct Lesson: Identifiable {
    let id: String
    let icon: String
    let title: String
    let summary: String
    let introduction: String
    let questions: [RoadQuestion]

    // A lesson is complete only when every question ID is in the completed set.
    func isComplete(completed: Set<String>) -> Bool {
        for question in questions {
            if completed.contains(question.id) == false {
                return false
            }
        }

        return true
    }
}
