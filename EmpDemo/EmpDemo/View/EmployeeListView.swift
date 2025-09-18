//
//  EmployeeListView.swift
//  EmpDemo
//
//  Created by shirish gayakawad on 17/09/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct EmployeeListView: View {
    @StateObject private var vm = EmployeesViewModel()
    @State private var isTargeted = false
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            Group {
                if vm.employees.isEmpty {
                    VStack(spacing: 12) {
                        Text("No employees")
                            .font(.headline)
                        Text("Drop a JSON file here or add employees.json to the app bundle.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                } else {
                    List {
                        ForEach(vm.employees) { emp in
                            NavigationLink(destination: EmployeeDetailView(employee: emp)) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(emp.fullName)
                                            .font(.headline)
                                        Text(emp.jobTitle ?? "-")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    if emp.isManager == true {
                                        Text("Mgr")
                                            .font(.caption)
                                            .padding(6)
                                            .background(RoundedRectangle(cornerRadius: 6).opacity(0.12))
                                    }
                                }
                                .padding(.vertical, 6)
                            }
                        }
                        .onMove { vm.move(from: $0, to: $1) }
                        .onDelete(perform: vm.delete)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Employees")
            .toolbar { EditButton() }
            .onReceive(vm.$errorMessage) { msg in
                showAlert = (msg != nil)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(vm.errorMessage ?? ""), dismissButton: .default(Text("OK")) {
                    vm.errorMessage = nil
                })
            }
            .onDrop(of: [UTType.fileURL.identifier, UTType.plainText.identifier], isTargeted: $isTargeted) { providers in
                vm.handleDroppedItems(providers: providers) { _ in /* optional completion */ }
                return true // we accept the drop synchronously; actual processing async
            }
            .overlay {
                if isTargeted {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(style: StrokeStyle(lineWidth: 3, dash: [6]))
                        .padding()
                        .overlay(Text("Drop JSON file or text here").font(.headline))
                        .transition(.opacity)
                }
            }
        }
    }
}

struct EmployeeListView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeListView()
    }
}
