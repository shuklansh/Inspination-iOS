//
//  HomeView.swift
//  Inspination iOS
//
//  Created by Ansh Shukla on 07/09/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = PhotosViewModel(controller: FetchController()
    )
    @Binding var queryText: String
    var body: some View {
        VStack {
            TextField("query", text: $queryText)
                .keyboardType(.numberPad)
                .foregroundStyle(.black)
                .textFieldStyle(.roundedBorder)
                .onChange(of: queryText,
                          {
                    Task {
                                await viewModel.fetchImagesForQuery(for: queryText)
                                }
                })
            switch viewModel.status {
                case .SUCCESS(let data):
                    if (data.photos != nil) {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack {
                                ForEach(data.photos, id:\.self) { imageLink in
                                    AsyncImage(url:
                                        imageLink.src.large, content: {
                                        image in image
                                            .resizable()
                                            .scaledToFill()
                                    }, placeholder: { ProgressView() })
                                    .cornerRadius(24)
                                    .padding(.top, 60)
                                }
                            }
                        }
//                        AsyncImage(
//                            url: URL(string: data.photos.first!.src.large)
//                        )
                    } else {
                        Text("not found")
                    }
                case .FAILURE(let error):
                Text("error : \(error.localizedDescription.description)")
                default:
                ZStack(alignment: .bottom) {
                    ProgressView()
                }
            }
        }.onAppear {
            Task {
                await viewModel.fetchImagesForQuery(for: queryText)
            }
        }
    }
}

//#Preview {
//    HomeView(
//        ""
//    )
//}
