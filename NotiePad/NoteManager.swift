//
//  NoteManager.swift
//  NotiePad
//
//  Created by Mohammad Gharib Joorkouyeh on 17/12/24.
//

import SwiftData
import SwiftUI

class NoteManager: ObservableObject {
    // We no longer need this since SwiftData's @Query will be used in NotieBooksView
    @Published var notes: [Note] = []
    
    /// Create a new note
    func createNote(title: String, content: NSAttributedString, modelContext: ModelContext) {
        let newNote = Note(title: title, content: content)
        modelContext.insert(newNote) // ✅ Use SwiftData modelContext for inserting notes
    }

    /// Delete a note
    func deleteNote(note: Note, modelContext: ModelContext) {
        modelContext.delete(note) // ✅ Use modelContext to delete notes from the database
    }

    /// Update a note
    func updateNote(note: Note, title: String, content: NSAttributedString, modelContext: ModelContext) {
        note.title = title
        note.content = try! content.data(from: NSRange(location: 0, length: content.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtf])
        note.lastEdited = Date()
    }
}
