//
//  Constants.swift
//  iOS-Dev-Case
//
//  Created by Yusuf Gürel on 6.03.2025.
//

import Foundation

struct Constants {
    static let baseURL = "https://jsonplaceholder.typicode.com"
    
    static let usersEndpoint = "/users"

    static var usersURL: URL {
        return URL(string: baseURL + usersEndpoint)!
    }
}
