//
//  ExtensionFunctions.swift
//  Inspination iOS
//
//  Created by Ansh Shukla on 07/09/24.
//

import Foundation
import Photos
import UIKit

extension String {
    var replaceSpaceWithPlus: String {
        self.replacingOccurrences(of: " ", with: "+")
    }
    var replaceSpaceWithNothing: String {
        self.replacingOccurrences(of: " ", with: "")
    }
    var lowerNoSpaces: String  {
        self.replaceSpaceWithNothing.lowercased()
    }
}

typealias SaveImageCompletion = (Bool) -> Void

func saveImageToGallery(
    imageURLString: String,
    onCompletion: @escaping SaveImageCompletion
) {
    guard let url = URL(string: imageURLString) else {
        DispatchQueue.main.async {
            onCompletion(false)
        }
        return
    }
    
    PHPhotoLibrary.requestAuthorization { status in
        if status == .authorized {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil, let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        onCompletion(false)
                    }
                    return
                }
                
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { success, error in
                    DispatchQueue.main.async {
                        onCompletion(success)
                    }
                }
            }.resume()
        } else {
            DispatchQueue.main.async {
                onCompletion(false)
            }
        }
    }
}

class Downloader : ObservableObject {
    func downloadImage(imageUrlStr: String) {
              let task = URLSession.shared.dataTask(with: URLRequest(url: URL(string: imageUrlStr)!), completionHandler: {(data, response, error) -> Void in
                
                  guard let data = data else {
                      print("No image data")
                      return
                  }
                  
                  do {
                      try data.write(to: self.getDocumentsDirectory().appendingPathComponent("image.jpg"))
                      print("Image saved to: ",self.getDocumentsDirectory())
                  } catch {
                      print(error)
                  }
                  
              })
              // Start the download.
              task.resume()
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}


