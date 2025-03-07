//
//  UsersAPI.swift
//  iOS-Dev-Case
//
//  Created by Yusuf Gürel on 6.03.2025.
//

import Foundation
import Combine

final class UsersAPI: APIService {
    var cancellables = Set<AnyCancellable>()
    private let usersURL = Constants.usersURL
    
    func fetchUsers(completion: @escaping (Result<UserModel, APIError>) -> ()) {
        getRequest(url: usersURL, completion: completion)
    }
    
    // MARK: - Generic network layer for GET HTTP call.
    private func getRequest<T: Decodable>(url: URL, completion: @escaping (Result<T, APIError>) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Network error
            guard error == nil else {
                print(error?.localizedDescription ?? "Network error")
                completion(.failure(.networkError))
                return
            }
            
            // No server response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.failed))
                return
            }
            
            switch httpResponse.statusCode {
            // Code 200, check if data exists
            case (200...299):
                if let data = data {
                    do {
                        let output = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(output))
                    } catch {
                        print("Decoding error: \(error)")
                        completion(.failure(.decodeError))
                        return
                    }
                } else {
                    completion(.failure(.failed))
                }
            default:
                completion(.failure(.notFound))
            }
        }
        task.resume()
    }
}
