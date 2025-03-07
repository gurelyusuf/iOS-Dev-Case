//
//  UserCellViewModel.swift
//  iOS-Dev-Case
//
//  Created by Yusuf Gürel on 6.03.2025.
//

import Foundation

struct UserCellViewModel {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: String
    let phone: String
    let website: String
    let company: String
    let user: User

    init(user: User) {
        self.id = user.id
        self.name = user.name
        self.username = user.username
        self.email = user.email
        self.address = "\(user.address.street), \(user.address.suite), \(user.address.city), \(user.address.zipcode)"
        self.phone = user.phone
        self.website = user.website
        self.company = user.company.name
        self.user = user
    }
}
