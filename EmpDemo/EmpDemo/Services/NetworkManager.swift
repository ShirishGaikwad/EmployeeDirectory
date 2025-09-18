//
//  NetworkManager.swift
//  EmpDemo
//
//  Created by shirish gayakawad on 17/09/25.
//

import Foundation

enum NetworkError: Error {
    case fileNotFound
    case decodingError(Error)
}

class NetworkManager {
    static func loadEmployeesFromBundle(filename: String = "employees") throws -> [Employee] {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw NetworkError.fileNotFound
        }
        let data = try Data(contentsOf: url)
        return try parseEmployees(from: data)
    }

    static func parseEmployees(from data: Data) throws -> [Employee] {
        do {
            let decoder = JSONDecoder()
            let resp = try decoder.decode(EmployeesResponse.self, from: data)
            return resp.employees
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
