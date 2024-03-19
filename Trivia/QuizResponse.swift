//
//  QuizResponse.swift
//  Trivia
//
//  Created by Jack Joseph on 3/18/24.
//

import Foundation
struct QuizResponse: Decodable {
    let responseCode: Int
    let results: [TriviaQuestion]
    
    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
    }
}
