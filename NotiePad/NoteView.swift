//
//  NoteView.swift
//  NotiePad
//
//  Created by Mohammad Gharib Joorkouyeh on 17/12/24.
//

import SwiftUI
import SwiftData
import UIKit

struct NoteView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var noteManager: NoteManager // ✅ Use EnvironmentObject instead of creating a new instance
    @State private var noteTitle: String = ""
    @State private var attributedText: NSMutableAttributedString = NSMutableAttributedString(string: "")
    @State private var selectedFont: String = "System"
    @State private var fontSize: CGFloat = 18
    @State private var isBold: Bool = false
    @State private var isItalic: Bool = false
    @State private var isUnderlined: Bool = false
    @State private var showFontMenu: Bool = false
    @State private var showFontSizeMenu: Bool = false
    @Environment(\.presentationMode) var presentationMode

    let fonts = ["System", "Arial", "Courier", "Georgia", "Helvetica"]
    let presetSizes: [CGFloat] = [10, 13, 16, 18, 24, 32, 48]

    var body: some View {
        VStack {
            // Title Input
            TextField("Title", text: $noteTitle)
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
        .navigationTitle("New Note")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveNote()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }

    func applyAttributes() {
        guard let textView = RichTextEditor.currentTextView else { return }

        // Retrieve the current font descriptor
        let currentFont = (textView.typingAttributes[.font] as? UIFont) ?? UIFont.systemFont(ofSize: fontSize)
        _ = currentFont.fontDescriptor

        // Create a new font based on the selected font name
        let newFont = UIFont(name: selectedFont, size: fontSize)?
            .withTraits(isBold: isBold, isItalic: isItalic) ?? currentFont

        // Update the typing attributes
        var newAttributes: [NSAttributedString.Key: Any] = [.font: newFont]
        if isUnderlined {
            newAttributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        } else {
            newAttributes[.underlineStyle] = 0 // Use 0 to indicate no underline
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
        let newNote = Note(title: noteTitle, content: attributedText)
       
        modelContext.insert(newNote)
    }
}

extension UIFont {
    func withTraits(isBold: Bool, isItalic: Bool) -> UIFont {
        var traits: UIFontDescriptor.SymbolicTraits = []
        if isBold { traits.insert(.traitBold) }
        if isItalic { traits.insert(.traitItalic) }

        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}

struct RichTextEditor: UIViewRepresentable {
    @Binding var attributedText: NSMutableAttributedString

    static var currentTextView: UITextView? // Hold reference to UITextView

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.delegate = context.coordinator
        textView.attributedText = attributedText
        textView.font = UIFont.systemFont(ofSize: 16)
        RichTextEditor.currentTextView = textView // Save reference
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedText
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: RichTextEditor

        init(_ parent: RichTextEditor) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        }
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NoteView()
        }
    }
}
