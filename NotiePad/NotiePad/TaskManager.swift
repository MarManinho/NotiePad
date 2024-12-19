//
//  TaskManager.swift
//  NotiePad
//
//  Created by Mohammad Gharib Joorkouyeh on 18/12/24.
//

import SwiftUI

class TaskManager: ObservableObject {
    static let shared = TaskManager() // Singleton instance
    
    @Published var tasks: [Task] = []
    
    private init() {} // Prevent external instantiation
    
    func addTask(name: String, dueDate: Date) {
        let newTask = Task(name: name, dueDate: dueDate)
        tasks.append(newTask)
    }
    
    func toggleTaskCompletion(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    func updateTask(task: Task, newName: String, newDueDate: Date) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].name = newName
            tasks[index].dueDate = newDueDate
        }
    }
    
    func deleteTask(task: Task) {
        tasks.removeAll { $0.id == task.id }
    }
}
