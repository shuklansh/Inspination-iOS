//
//  ContentView.swift
//  Inspination iOS
//
//  Created by Ansh Shukla on 07/09/24.
//

import SwiftUI

struct ContentView: View {
    @State var query = ""
    var body: some View {
        NavigationStack {
            HomeView(
                queryText:$query
            )
        }
    }
}

//#Preview {
//    ContentView()
//}
