import Foundation

struct TriviaQuestion: Decodable {
    let type: String
    let difficulty: String
    let category: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]

    enum CodingKeys: String, CodingKey {
        case type
        case difficulty
        case category
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }

    var isTrueFalseQuestion: Bool {
        return incorrectAnswers.count == 1 && (incorrectAnswers[0] == "True" || incorrectAnswers[0] == "False")
    }
}
