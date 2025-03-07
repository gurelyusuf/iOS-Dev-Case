//
//  iOS_Dev_CaseTests.swift
//  iOS-Dev-CaseTests
//
//  Created by Yusuf Gürel on 6.03.2025.
//

import XCTest
import Combine
@testable import iOS_Dev_Case

final class UsersAPITests: XCTestCase {
    private var usersAPI: UsersAPI!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        usersAPI = UsersAPI()
    }

    override func tearDown() {
        usersAPI = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testFetchUsersSuccess() {

        let expectation = XCTestExpectation(description: "Fetch users successfully")


        usersAPI.fetchUsers { result in
            // Assert
            switch result {
            case .success(let users):
                XCTAssertFalse(users.isEmpty, "Users array should not be empty")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Fetching users failed with error: \(error)")
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchUsersFailureWithInvalidURL() {

        let expectation = XCTestExpectation(description: "Fetch users with invalid URL")
        let invalidURL = URL(string: "https://invalid.url")!
        let mockAPI = MockUsersAPI(url: invalidURL)


        mockAPI.fetchUsers { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Fetching users should fail with invalid URL")
            case .failure(let error):
                XCTAssertEqual(error, .invalidURL, "Error should be invalidURL")
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchUsersFailureWithDecodeError() {

        let expectation = XCTestExpectation(description: "Fetch users with decode error")
        let invalidDataURL = URL(string: "https://jsonplaceholder.typicode.com/invalid")!
        let mockAPI = MockUsersAPI(url: invalidDataURL)


        mockAPI.fetchUsers { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Fetching users should fail with decode error")
            case .failure(let error):
                XCTAssertEqual(error, .decodeError, "Error should be decodeError")
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }
}

// MARK: - Mock UsersAPI for Testing
final class MockUsersAPI: APIService {
    private let url: URL

    init(url: URL) {
        self.url = url
    }

    func fetchUsers(completion: @escaping (Result<UserModel, APIError>) -> ()) {
        // Simulate invalid URL
        if url.absoluteString == "https://invalid.url" {
            completion(.failure(.invalidURL))
            return
        }

        // Simulate decode error
        if url.absoluteString == "https://jsonplaceholder.typicode.com/invalid" {
            // invalid JSON data
            let invalidData = """
            {
                "invalidProperty": "This is invalid data"
            }
            """.data(using: .utf8)!
            do {
                // decode user model
                _ = try JSONDecoder().decode(UserModel.self, from: invalidData)
                completion(.failure(.failed))
            } catch {
                // decode error
                completion(.failure(.decodeError))
            }
            return
        }

        // normal api request for other errors
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.networkError))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.failed))
                return
            }

            switch httpResponse.statusCode {
            case 200...299:
                if let data = data {
                    do {
                        let output = try JSONDecoder().decode(UserModel.self, from: data)
                        completion(.success(output))
                    } catch {
                        completion(.failure(.decodeError))
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

// MARK: - Invalid Model for Testing
struct InvalidModel: Decodable {
    let invalidProperty: String
}
