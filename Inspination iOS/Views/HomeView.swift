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
    @StateObject private var viewModel = PhotosViewModel(controller: FetchController()
    )
    @StateObject private var downloader = Downloader()
    
    @State private var showSaveAlert = false
        @State private var saveSuccess = false

    @Binding var queryText: String
    var body: some View {
        VStack {
            TextField("query", text: $queryText)
                .keyboardType(.numberPad)
                .foregroundStyle(.black)
                .textFieldStyle(.roundedBorder)
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
                                    }, placeholder: {
                                        ProgressView()
                                    })
                                    .cornerRadius(24)
                                    .padding(.top, 60)
                                    
                                    ZStack {
                                        Text("Download")
                                            .padding(12)
                                            .foregroundColor(.white)
                                    }
                                    .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.black))
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
                    }
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
