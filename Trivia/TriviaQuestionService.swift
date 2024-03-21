//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Jack Joseph on 3/17/24.
//

import Foundation

class TriviaQuestionService {
    //fetching the questions and answers from the API
    static let shared = TriviaQuestionService()
    let url = URL(string: "https://opentdb.com/api.php?amount=10")!
    
    func fetchQuestions(completion: @escaping (Result<[TriviaQuestion], Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let quizResponse = try decoder.decode(QuizResponse.self, from: data)
                completion(.success(quizResponse.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

