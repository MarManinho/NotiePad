//
//  CreateView.swift
//  NotiePad
//
//  Created by Mohammad Gharib Joorkouyeh on 17/12/24.
//

import SwiftUI
import SwiftData

struct CreateView: View {
    @State private var searchText: String = ""
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass") // Search icon
                            .foregroundColor(.gray)

                        TextField("Find notes, tasks or NotieBooks", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(.primary)

                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = "" // Clear the search text
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(15)
                    .padding([.horizontal, .top])

                    // Buttons
                    HStack {
                        // New Note Button with Image
                        VStack(spacing: 4) {
                            NavigationLink(destination: NoteView()) {
                                Image("NewNote")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 180, height: 130)
                            }

                            NavigationLink(destination: NoteView()) {
                                Text("Add a new note")
                                    .font(.custom("Helvetica Bold", size: 16))
                                    .foregroundColor(.black)
                            }
                        }

                        Spacer()

                        // New Task Button with Image
                        VStack(spacing: 4) {
                            Button(action: {
                                // Action for New Task Image Button
                            }) {
                                Image("NewTask")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 180, height: 130)
                            }

                            Button(action: {
                                // Action for Add Task Text Button
                            }) {
                                Text("Add a new task")
                                    .font(.custom("Helvetica Bold", size: 16))
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding()

                    // Notebooks Section
                    Text("Recent NotieBooks")
                        .font(.custom("Helvetica Bold", size: 24))
                        .padding(.top)
                        .padding(.horizontal)

                    Text("You don't have any Notebooks, Create one and it would show up here.")
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(.gray)

                    // Tasks Section
                    Text("Recent Tasks")
                        .font(.custom("Helvetica Bold", size: 24))
                        .padding(.top)
                        .padding(.horizontal)

                    Text("You don't have any Tasks, Create one and it would show up here.")
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(.gray)
                }
            }
        }
        .background(Color(.systemBackground))
    }
}

