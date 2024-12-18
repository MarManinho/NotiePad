//
//  NotieBooksView.swift
//  NotiePad
//
//  Created by Mohammad Gharib Joorkouyeh on 17/12/24.
//

import SwiftUI
import SwiftData

struct NotieBooksView: View {
    @Query(sort: \Note.lastEdited, order: .reverse) var notes: [Note]
 // ✅ Auto-load notes from SwiftData

    var body: some View {
        List {
            ForEach(notes) { note in
                NavigationLink(destination: NoteViewEditor(note: .constant(note))) {
                    VStack(alignment: .leading) {
                        Text(note.title)
                        Text("Edited \(formattedDate(note.lastEdited))")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

