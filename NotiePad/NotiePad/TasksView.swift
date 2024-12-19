//
//  TasksView.swift
//  NotiePad
//
//  Created by Mohammad Gharib Joorkouyeh on 18/12/24.
//

import SwiftUI

struct TasksView: View {
    @StateObject private var taskManager = TaskManager.shared // Use the shared instance instead of a new one
    @State private var isPresentingTaskEditor = false
    @State private var taskToEdit: Task?

    var body: some View {
        NavigationView {
            VStack {
                if taskManager.tasks.isEmpty {
                    VStack {
                        Text("No tasks to show here, Start making one by clicking the plus button")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                        Button(action: { isPresentingTaskEditor = true }) {
                            Image(systemName: "plus.circle")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding()
                                .background(Circle().foregroundColor(.blue))
                        }
                    }
                } else {
                    List {
                        Section(header: Text("Active Tasks")) {
                            ForEach(taskManager.tasks.filter { !$0.isCompleted }) { task in
                                TaskRow(task: task, onEdit: {
                                    taskToEdit = task
                                    isPresentingTaskEditor = true
                                }, onToggleCompletion: {
                                    taskManager.toggleTaskCompletion(task: task)
                                })
                                .swipeActions {
                                    Button(role: .destructive) {
                                        taskManager.deleteTask(task: task)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        Section(header: Text("Finished Tasks")) {
                            ForEach(taskManager.tasks.filter { $0.isCompleted }) { task in
                                TaskRow(task: task, onEdit: {
                                    taskToEdit = task
                                    isPresentingTaskEditor = true
                                }, onToggleCompletion: {
                                    taskManager.toggleTaskCompletion(task: task)
                                })
                                .swipeActions {
                                    Button(role: .destructive) {
                                        taskManager.deleteTask(task: task)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isPresentingTaskEditor = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingTaskEditor) {
                TaskViewEditor(task: $taskToEdit, onSave: { name, dueDate in
                    if let taskToEdit = taskToEdit {
                        taskManager.updateTask(task: taskToEdit, newName: name, newDueDate: dueDate)
                    } else {
                        taskManager.addTask(name: name, dueDate: dueDate)
                    }
                    self.taskToEdit = nil
                    isPresentingTaskEditor = false
                })
            }
        }
    }
}
