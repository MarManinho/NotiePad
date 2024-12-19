//
//  TaskViewEditor.swift
//  NotiePad
//
//  Created by Mohammad Gharib Joorkouyeh on 18/12/24.
//

import SwiftUI

struct TaskViewEditor: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var dueDate: Date = Date()
    @Binding var task: Task?
    let onSave: (String, Date) -> Void

    var body: some View {
        NavigationView {
            Form {
                TextField("Task Name", text: $name)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
            }
            .navigationTitle(task == nil ? "New Task" : "Edit Task")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onSave(name, dueDate)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .onAppear {
            if let task = task {
                name = task.name
                dueDate = task.dueDate
            }
        }
    }
}
