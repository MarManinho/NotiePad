//
//  NotiePadApp.swift
//  NotiePad
//
//  Created by Mohammad Gharib Joorkouyeh on 17/12/24.
//

import SwiftUI
import SwiftData

@main
struct NotiePadApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(NoteManager())
        }
        .modelContainer(for: Note.self) // ✅ Enable SwiftData model for the Note model
    }
}
