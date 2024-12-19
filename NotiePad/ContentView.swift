//
//  ContentView.swift
//  NotiePad
//
//  Created by Mohammad Gharib Joorkouyeh on 17/12/24.
//

//
//  ContentView.swift
//  NotiePad
//
//  Created by Mohammad Gharib Joorkouyeh on 10/12/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                            Image(systemName: "line.3.horizontal.circle")
                                .font(.title)
                            Spacer()
                            Text("NotiePad")
                                .font(.custom("SignPainter", size: 50))
                                .multilineTextAlignment(.center)
                            Spacer()
                            Image(systemName: "ellipsis.circle")
                                .font(.title)
                }
                .padding()
           
            TabView {
                NotieBooksView()
                    .tabItem { Label("NotieBooks", systemImage: "book.fill") }

                CreateView()
                    .tabItem { Label("Create", systemImage: "plus.circle") }
                
                TasksView()
                                
                    .tabItem { Label("Tasks", systemImage: "checkmark.circle")
                                    }
            }
        }
        }
    }
}
#Preview {
    ContentView()
}
