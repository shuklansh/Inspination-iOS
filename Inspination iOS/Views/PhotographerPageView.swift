//
//  PhotographerPageView.swift
//  Inspination iOS
//
//  Created by Ansh Shukla on 15/09/24.
//

import SwiftUI

struct PhotographerPageView: View {
    @Environment(\.dismiss) var dismissCurrentScreen
    var artistLink: String
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .onTapGesture {
                        dismissCurrentScreen()
                    }
                    .padding(15)
                Spacer()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            CustomWebView(url: URL(string: artistLink))
        }
    }
}
