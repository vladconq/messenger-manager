//
//  APIService.swift
//  message-manager-uikit
//
//  Created by mainuser on 25.04.2022.
//

import Foundation

class APIService {
    
    // MARK: - PROPERTIES
    
    static let shared = APIService()
    private var offset = 0
    
    // MARK: - INIT
    
    private init() {}
    
    // MARK: - API CALL
    
    func fetchMessages(completion: @escaping (Result<[String], Error>) -> Void) {
        // fake timeout for displaying loader (zero timeout for initial offset)
        DispatchQueue.global().asyncAfter(deadline: .now() + (offset == 0 ? 0 : 1)) {
            guard let url = URL(string: "https://numero-logy-app.org.in/getMessages?offset=\(self.offset)") else { return }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    print("No data")
                    return
                }
                
                guard error == nil else {
                    print("Error: \(error!)")
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    guard response.statusCode >= 200 && response.statusCode < 300 else {
                        print("Bad status code: \(response.statusCode)")
                        return
                    }
                } else {
                    print("Not HTTP Response")
                }
                
                do {
                    let messages = try JSONDecoder().decode(Messages.self, from: data)
                    self.offset += 20
                    completion(.success(messages.result))
                } catch {
                    completion(.failure(error))
                }
                
            }.resume()
        }
    }
}
