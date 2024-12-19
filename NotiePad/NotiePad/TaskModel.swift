//
//  TaskModel.swift
//  NotiePad
//
//  Created by Mohammad Gharib Joorkouyeh on 18/12/24.
//

import Foundation

struct Task: Identifiable {
    let id: UUID
    var name: String
    var dueDate: Date
    var isCompleted: Bool
    
    init(name: String, dueDate: Date, isCompleted: Bool = false) {
        self.id = UUID()
        self.name = name
        self.dueDate = dueDate
        self.isCompleted = isCompleted
    }
}
