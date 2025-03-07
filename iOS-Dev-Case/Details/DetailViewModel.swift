//
//  DetailViewModel.swift
//  iOS-Dev-Case
//
//  Created by Yusuf Gürel on 6.03.2025.
//

import Foundation
import Combine

final class DetailViewModel {
    let user: User
    
    @Published private(set) var name: String
    @Published private(set) var username: String
    @Published private(set) var email: String
    @Published private(set) var address: String
    @Published private(set) var phone: String
    @Published private(set) var website: String
    @Published private(set) var companyName: String
    @Published private(set) var companyCatchPhrase: String
    @Published private(set) var companyBS: String
    
    // Dependency injection
    init(user: User) {
        self.user = user
        self.name = user.name
        self.username = user.username
        self.email = user.email
        self.address = "\(user.address.street), \(user.address.suite), \(user.address.city), \(user.address.zipcode)"
        self.phone = user.phone
        self.website = user.website
        self.companyName = user.company.name
        self.companyCatchPhrase = user.company.catchPhrase
        self.companyBS = user.company.bs
    }
}
