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
            TextField("query", text: $queryText)
                .keyboardType(.alphabet)
                .foregroundStyle(.black)
                .textFieldStyle(.roundedBorder)
                .padding(.vertical, 20)
                .padding(.horizontal, 8)
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
                                                saveImageToGallery(imageURLString: imageLink.src.large.absoluteString)
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
    func saveImageToGallery(imageURLString: String) {
            guard let url = URL(string: imageURLString) else {
                showSaveAlert = true
                saveSuccess = false
                return
            }
            
            // Request permission if needed
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    // Download the image
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data, error == nil, let image = UIImage(data: data) else {
                            DispatchQueue.main.async {
                                showSaveAlert = true
                                saveSuccess = false
                            }
                            return
                        }
                        
                        // Save the image to the photo library
                        PHPhotoLibrary.shared().performChanges({
                            PHAssetChangeRequest.creationRequestForAsset(from: image)
                        }) { success, error in
                            DispatchQueue.main.async {
                                showSaveAlert = true
                                saveSuccess = success
                            }
                        }
                    }.resume()
                } else {
                    DispatchQueue.main.async {
                        showSaveAlert = true
                        saveSuccess = false
                    }
                }
            }
        }
}

//#Preview {
//    HomeView(
//        ""
//    )
//}
