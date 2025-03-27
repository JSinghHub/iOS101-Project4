//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Jaskirat Singh on 3/26/25.
//

// TriviaQuestionService.swift

import Foundation

class TriviaQuestionService {
    
    func fetchTriviaQuestions(completion: @escaping (Result<[TriviaQuestion], Error>) -> Void) {
        let urlString = "https://opentdb.com/api.php?amount=5" // You can modify the amount here
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Invalid HTTP Status Code", code: 0, userInfo: nil)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data Received", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let triviaResponse = try decoder.decode(TriviaResponse.self, from: data)
                let questions = triviaResponse.results
                DispatchQueue.main.async {
                    completion(.success(questions))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
