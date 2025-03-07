//
//  UserViewModel.swift
//  iOS-Dev-Case
//
//  Created by Yusuf Gürel on 6.03.2025.
//

import Foundation
import Combine

final class UserViewModel {
    private var usersData: UserModel?
    private var userViewModel = [UserCellViewModel]()
    private let apiService: APIService
    private var subscriptions = Set<AnyCancellable>()


    var users: [UserCellViewModel] {
        return userViewModel
    }

    var updateResult = PassthroughSubject<Bool, APIError>()
    
    init(apiService: APIService = UsersAPI()) {
        self.apiService = apiService
        getUsers()
    }

    func getUsers() {
        apiService.fetchUsers { [weak self] result in
            switch result {
            case .success(let response):
                self?.usersData = response
                self?.parseData(isRefresh: true)
            case .failure(let error):
                print(error.rawValue)
                self?.updateResult.send(completion: .failure(error))
            }
        }
    }
}

extension UserViewModel {
    private func parseData(isRefresh: Bool = false) {
        guard let data = usersData, !data.isEmpty else {
            updateResult.send(false)
            return
        }
        
        // Clear existing data if already exist
        if isRefresh {
            userViewModel.removeAll()
        }
        
        data.forEach { userViewModel.append(UserCellViewModel(user: $0)) }
        updateResult.send(true)
    }
}
