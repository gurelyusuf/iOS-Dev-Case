//
//  UserViewModelProtocol.swift
//  iOS-Dev-Case
//
//  Created by Yusuf Gürel on 6.03.2025.
//

import Foundation

protocol UserCell {
    var user: User { get }
    var name: String { get }
    var email: String { get }
}

protocol UserDetails: UserCell {
    var username: String { get }
    var phone: String { get }
    var website: String { get }
    var address: String { get }
    var city: String { get }
    var zipcode: String { get }
    var country: String { get }
    var company: String { get }
}

