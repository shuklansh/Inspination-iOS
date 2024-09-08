//
//  HomeView.swift
//  Inspination iOS
//
//  Created by Ansh Shukla on 07/09/24.
//

import SwiftUI
import Photos
import UIKit

struct HomeView: View {
    @StateObject private var viewModel = PhotosViewModel(controller: FetchController())
    @State private var showSaveAlert = false
    @State private var saveSuccess = false
    @State private var imageLoaded = false

    @Binding var queryText: String
    var body: some View {
        VStack {
            Text("InspiNation")
                .foregroundColor(.white)
                .bold()
                .padding(.vertical, 14)
                .padding(.horizontal, 4)
                .frame(alignment: .leading)
            TextField("what are you searching for?", text: $queryText)
                .keyboardType(.alphabet)
                .foregroundStyle(.white.opacity(0.75))
                .padding(.vertical, 20)
                .padding(.horizontal, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20) // Set corner radius to 20
                        .fill(Color.purple.opacity(0.2)) // Background color
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray, lineWidth: 1) // Optional border
                )
                .onChange(of: queryText,
                          {
                    
                    if (queryText != "") {
                        Task {
                            await viewModel.fetchImagesForQuery(for: queryText)
                        }
                    }
                })
            Spacer()
            switch viewModel.status {
                case .SUCCESS(let data):
                if data.photos.count > 0 {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            ForEach(data.photos, id: \.self) { imageLink in
                                ZStack(alignment: .bottomLeading) {
                                    AsyncImage(url: imageLink.src.large, content: { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .onAppear {
                                                imageLoaded = true // Set flag when image appears
                                            }
                                    }, placeholder: {
                                        ZStack(alignment: .center) {
                                            ProgressView()
                                        }.frame(width: 120,height: 120)
                                    })
                                    .cornerRadius(24)
                                    if (imageLoaded) {
                                        ZStack {
                                            Text("Download")
                                                .padding(12)
                                                .foregroundColor(.white)
                                        }
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.black.opacity(0.91), .purple.opacity(0.91)]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                            .mask(
                                                RoundedRectangle(cornerRadius: 12) // Apply gradient to RoundedRectangle
                                            )
                                        )
                                        .onTapGesture {
                                            Task {
                                        saveImageToGallery(imageURLString: imageLink.src.large.absoluteString) { success in
                                                    self.saveSuccess = success
                                                    self.showSaveAlert = true
                                                }
                                            }
                                        }
                                        .alert(isPresented: $showSaveAlert) {
                                            Alert(title: Text(saveSuccess ? "Success" : "Error"), message: Text(saveSuccess ? "Image saved to gallery." : "Failed to save image."), dismissButton: .default(Text("OK")))
                                        }
                                        .padding(14)
                                    }
                                }
                            }
                        }.padding(8)
                    }
                } else {
                    Text("Not found")
                }
            case .NOT_INITIATED:
                Text("Find your inspiration")
                    .foregroundColor(.white)
                    .padding()
                case .FAILURE(let error):
                    Text("not found")
//                    print(error.localizedDescription.description)
                default:
                    ZStack(alignment: .bottom) {
                        ProgressView()
                    }.frame(width: 120,height: 120)
            }

        }.onAppear {
            if (queryText != "") {
                Task {
                    await viewModel.fetchImagesForQuery(for: queryText)
                }
            }
        }
        .background(
                    LinearGradient(gradient: Gradient(colors: [.black, .purple]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                )
        
    }
}
