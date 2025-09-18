//
//  Employee.swift
//  EmpDemo
//
//  Created by shirish gayakawad on 17/09/25.
//

import Foundation

struct Employee: Identifiable, Codable, Equatable {
    var id: String
    var firstName: String
    var lastName: String
    var jobTitle: String?
    var department: String?
    var email: String?
    var phoneNumber: String?
    var hireDate: String?
    var salary: Int?
    var isManager: Bool?
    var address: Address?

    var fullName: String { "\(firstName) \(lastName)" }
}

struct Address: Codable, Equatable {
    var street: String?
    var city: String?
    var state: String?
    var zip: String?
}
