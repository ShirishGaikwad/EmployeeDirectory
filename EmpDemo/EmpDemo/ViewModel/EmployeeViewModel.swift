//
//  EmployeeViewModel.swift
//  EmpDemo
//
//  Created by shirish gayakawad on 17/09/25.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

@MainActor
class EmployeesViewModel: ObservableObject {
    @Published var employees: [Employee] = []
    @Published var errorMessage: String?

    init() {
        loadInitial()
    }

    func loadInitial() {
        do {
            let list = try NetworkManager.loadEmployeesFromBundle()
            self.employees = list
        } catch {
            self.errorMessage = "Failed to load bundled employees: \(error)"
        }
    }

    func replaceWithJSONData(_ data: Data) {
        do {
            let parsed = try NetworkManager.parseEmployees(from: data)
            withAnimation {
                self.employees = parsed
            }
        } catch {
            self.errorMessage = "Invalid JSON: \(error.localizedDescription)"
        }
    }

    // Called from the view's .onDrop; keeps code small and robust
    func handleDroppedItems(providers: [NSItemProvider], completion: @escaping (Bool) -> Void) {
        // Prefer file URL drops
        if let provider = providers.first(where: { $0.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) }) {
            provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, error in
                if let err = error {
                    DispatchQueue.main.async {
                        self.errorMessage = err.localizedDescription
                        completion(false)
                    }
                    return
                }
                // item might be URL, Data or String path
                if let url = item as? URL {
                    do {
                        let data = try Data(contentsOf: url)
                        DispatchQueue.main.async {
                            self.replaceWithJSONData(data)
                            completion(true)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.errorMessage = "Failed reading dropped file: \(error.localizedDescription)"
                            completion(false)
                        }
                    }
                    return
                }
                if let data = item as? Data, let urlString = String(data: data, encoding: .utf8), let url = URL(string: urlString) {
                    do {
                        let data = try Data(contentsOf: url)
                        DispatchQueue.main.async {
                            self.replaceWithJSONData(data)
                            completion(true)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.errorMessage = "Failed reading dropped file URL: \(error.localizedDescription)"
                            completion(false)
                        }
                    }
                    return
                }

                DispatchQueue.main.async {
                    self.errorMessage = "Unsupported drop item format"
                    completion(false)
                }
            }
            return
        }

        // Plain text drop (raw JSON text)
        if let provider = providers.first(where: { $0.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) }) {
            provider.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { item, error in
                if let err = error {
                    DispatchQueue.main.async {
                        self.errorMessage = err.localizedDescription
                        completion(false)
                    }
                    return
                }
                if let s = item as? String, let data = s.data(using: .utf8) {
                    DispatchQueue.main.async {
                        self.replaceWithJSONData(data)
                        completion(true)
                    }
                    return
                }
                if let data = item as? Data, let text = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        if let d = text.data(using: .utf8) {
                            self.replaceWithJSONData(d)
                            completion(true)
                        } else {
                            self.errorMessage = "Could not parse dropped text"
                            completion(false)
                        }
                    }
                    return
                }

                DispatchQueue.main.async {
                    self.errorMessage = "Unsupported dropped text"
                    completion(false)
                }
            }
            return
        }

        completion(false)
    }

    // List helpers
    func move(from source: IndexSet, to destination: Int) {
        employees.move(fromOffsets: source, toOffset: destination)
    }

    func delete(at offsets: IndexSet) {
        employees.remove(atOffsets: offsets)
    }
}
