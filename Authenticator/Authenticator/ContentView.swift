//
//  ContentView.swift
//  Authenticator
//
//  Created by SZ HK on 22/4/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                AuthView()
                    .ignoresSafeArea(.all)
            }
        }
    }
}

#Preview {
    ContentView()
}
