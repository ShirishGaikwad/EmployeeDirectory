//
//  EmployeeDetailView.swift
//  EmpDemo
//
//  Created by shirish gayakawad on 17/09/25.
//

import SwiftUI

struct EmployeeDetailView: View {
    let employee: Employee

    var body: some View {
        Form {
            Section(header: Text("Name")) {
                Text(employee.fullName)
            }
            Section(header: Text("Job")) {
                Text(employee.jobTitle ?? "-")
                Text("Department: \(employee.department ?? "-")")
                if let isManager = employee.isManager {
                    Text("Manager: \(isManager ? "Yes" : "No")")
                }
            }
            Section(header: Text("Contact")) {
                Text("Email: \(employee.email ?? "-")")
                Text("Phone: \(employee.phoneNumber ?? "-")")
            }
            Section(header: Text("Address")) {
                Text(employee.address?.street ?? "-")
                Text("\(employee.address?.city ?? "-"), \(employee.address?.state ?? "-") \(employee.address?.zip ?? "-")")
            }
            Section(header: Text("Other")) {
                if let hire = employee.hireDate { Text("Hired: \(hire)") }
                if let salary = employee.salary { Text("Salary: \(salary)") }
            }
        }
        .navigationTitle(employee.firstName)
    }
}
