//
//  APIService.swift
//  iOS-Dev-Case
//
//  Created by Yusuf Gürel on 6.03.2025.
//

import Foundation

protocol APIService {
    func fetchUsers(completion: @escaping (Result<UserModel, APIError>) -> ())
}
