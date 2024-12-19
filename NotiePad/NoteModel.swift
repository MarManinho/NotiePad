//
//  NoteModel.swift
//  NotiePad
//
//  Created by Mohammad Gharib Joorkouyeh on 17/12/24.
//

import Foundation
import SwiftData

@Model
class Note: Identifiable {
    var id: UUID
    var title: String
    var content: Data
    var lastEdited: Date

    init(title: String, content: NSAttributedString) {
        self.id = UUID()
        self.title = title
        self.content = try! content.data(from: NSRange(location: 0, length: content.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtf])
        self.lastEdited = Date()
    }

    var attributedContent: NSAttributedString {
        return try! NSAttributedString(data: content, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
    }
}

