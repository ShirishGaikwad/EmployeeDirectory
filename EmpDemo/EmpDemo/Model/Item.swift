//
//  Item.swift
//  EmpDemo
//
//  Created by shirish gayakawad on 17/09/25.
//

import Foundation
import SwiftData
//
//@Model
//final class Item {
//    var timestamp: Date
//    
//    init(timestamp: Date) {
//        self.timestamp = timestamp
//    }
//}

struct Item: Identifiable {
    let id = UUID()
    let timestamp: Date = Date()
}
