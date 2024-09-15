//
//  DetailedView.swift
//  Inspination iOS
//
//  Created by Ansh Shukla on 15/09/24.
//

import SwiftUI

struct DetailedView: View {
    @Environment(\.dismiss) var dismissCurrentScreen
    var imageLink: URL
    var artistName: String
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
            AsyncImage(url: imageLink, content: { image in
                image
                    .resizable()
                    .scaledToFill()
            }, placeholder: {
                ZStack(alignment: .center) {
                    ProgressView()
                }.frame(width: 120,height: 120)
            })
            .cornerRadius(24)
            NavigationLink {
                // todo: webKitView
                PhotographerPageView(artistLink: artistLink)
                
            } label: {
                Text(artistName)
            }
        }
    }
}
