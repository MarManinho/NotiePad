//
//  TaskRow.swift
//  NotiePad
//
//  Created by Mohammad Gharib Joorkouyeh on 18/12/24.
//

import SwiftUI

struct TaskRow: View {
    let task: Task
    let onEdit: () -> Void
    let onToggleCompletion: () -> Void

    var body: some View {
        HStack {
            Button(action: onToggleCompletion) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .gray : .red)
            }
            Text(task.name)
                .strikethrough(task.isCompleted)
                .foregroundColor(task.isCompleted ? .gray : .primary)
                .onTapGesture {
                    onEdit()
                }
            Spacer()
            Text(task.dueDate, style: .date)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
