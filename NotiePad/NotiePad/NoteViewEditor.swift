//
//  NoteViewEditor.swift
//  NotiePad
//
//  Created by Mohammad Gharib Joorkouyeh on 17/12/24.
//

import SwiftUI
import SwiftData
import UIKit

struct NoteViewEditor: View {
    @Environment(\.modelContext) var modelContext // ✅ Access SwiftData context
    @Environment(\.presentationMode) var presentationMode // ✅ Used to dismiss the view
    @Binding var note: Note
    @State private var attributedText: NSMutableAttributedString
    @State private var selectedFont: String = "System"
    @State private var fontSize: CGFloat = 18
    @State private var isBold: Bool = false
    @State private var isItalic: Bool = false
    @State private var isUnderlined: Bool = false
    @State private var showFontMenu: Bool = false
    @State private var showFontSizeMenu: Bool = false

    let fonts = ["System", "Arial", "Courier", "Georgia", "Helvetica"]
    let presetSizes: [CGFloat] = [10, 13, 16, 18, 24, 32, 48]

    init(note: Binding<Note>) {
        _note = note
        _attributedText = State(initialValue: note.wrappedValue.attributedContent.mutableCopy() as! NSMutableAttributedString)
    }

    var body: some View {
        VStack {
            // Title Input
            TextField("Title", text: $note.title)
                .font(.system(size: 22, weight: .bold))
                .padding(.top, 10)
                .padding(.horizontal)

            // Divider
            Divider()

            // Rich Text Editor
            RichTextEditor(attributedText: $attributedText)
                .frame(minHeight: 300)
                .padding(.horizontal)

            Spacer()

            // Scrollable Toolbar
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    // Fonts Button
                    Button(action: {
                        showFontMenu.toggle()
                        showFontSizeMenu = false
                    }) {
                        Image(systemName: "textformat.alt")
                    }
                    .background(showFontMenu ? Color.blue.opacity(0.2) : Color.clear)
                    .cornerRadius(8)

                    if showFontMenu {
                        HStack {
                            ForEach(fonts, id: \.self) { font in
                                Button(action: {
                                    selectedFont = font
                                    applyAttributes()
                                    showFontMenu = false
                                }) {
                                    Text(font)
                                        .font(.system(size: 16))
                                        .padding(8)
                                        .background(selectedFont == font ? Color.blue.opacity(0.2) : Color.clear)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }

                    // Font Size Button
                    Button(action: {
                        showFontSizeMenu.toggle()
                        showFontMenu = false
                    }) {
                        Image(systemName: "textformat.size")
                    }
                    .background(showFontSizeMenu ? Color.blue.opacity(0.2) : Color.clear)
                    .cornerRadius(8)

                    if showFontSizeMenu {
                        HStack {
                            ForEach(presetSizes, id: \.self) { size in
                                Button(action: {
                                    fontSize = size
                                    applyAttributes()
                                    showFontSizeMenu = false
                                }) {
                                    Text("\(Int(size))")
                                        .font(.system(size: 16))
                                        .padding(8)
                                        .background(fontSize == size ? Color.blue.opacity(0.2) : Color.clear)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }

                    // Bold Button
                    Button(action: {
                        isBold.toggle()
                        applyAttributes()
                    }) {
                        Image(systemName: "bold")
                    }
                    .background(isBold ? Color.blue.opacity(0.2) : Color.clear)
                    .cornerRadius(8)

                    // Italic Button
                    Button(action: {
                        isItalic.toggle()
                        applyAttributes()
                    }) {
                        Image(systemName: "italic")
                    }
                    .background(isItalic ? Color.blue.opacity(0.2) : Color.clear)
                    .cornerRadius(8)

                    // Underline Button
                    Button(action: {
                        isUnderlined.toggle()
                        applyAttributes()
                    }) {
                        Image(systemName: "underline")
                    }
                    .background(isUnderlined ? Color.blue.opacity(0.2) : Color.clear)
                    .cornerRadius(8)
                }
                .padding()
            }
        }
        .navigationTitle("Edit Note")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveNote()
                    presentationMode.wrappedValue.dismiss() // ✅ Dismiss the view
                }
            }
        }
    }

    func applyAttributes() {
        guard let textView = RichTextEditor.currentTextView else { return }

        // Validate the font size to ensure it is not NaN or zero
        let validFontSize = fontSize.isNaN || fontSize <= 0 ? 18 : fontSize

        // Create a new font based on the selected font name
        let newFont = UIFont(name: selectedFont, size: validFontSize)?
            .withTraits(isBold: isBold, isItalic: isItalic) ?? UIFont.systemFont(ofSize: validFontSize)

        // Update the typing attributes
        var newAttributes: [NSAttributedString.Key: Any] = [.font: newFont]
        if isUnderlined {
            newAttributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        } else {
            newAttributes[.underlineStyle] = 0
        }

        // Update typing attributes to apply to newly typed text
        textView.typingAttributes = newAttributes

        // If text is selected, apply attributes to the selected range
        let selectedRange = textView.selectedRange
        if selectedRange.length > 0 {
            attributedText.addAttributes(newAttributes, range: selectedRange)
            textView.attributedText = attributedText
            textView.selectedRange = selectedRange
        }
    }

    func saveNote() {
        note.content = try! attributedText.data(from: NSRange(location: 0, length: attributedText.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtf])
        note.lastEdited = Date() // ✅ Update the last edited date
    }
}
