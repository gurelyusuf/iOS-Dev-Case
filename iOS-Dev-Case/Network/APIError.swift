//
//  APIError.swift
//  iOS-Dev-Case
//
//  Created by Yusuf Gürel on 6.03.2025.
//

import Foundation

enum APIError: String, Error {
    case notFound = "Error 404"
    case invalidURL = "Error: Invalid URL"
    case decodeError = "Decoding error"
    case networkError = "Network error"
    case failed = "An error has occured"
}
