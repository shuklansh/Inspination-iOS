//
//  ExtensionFunctions.swift
//  Inspination iOS
//
//  Created by Ansh Shukla on 07/09/24.
//

import Foundation

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

class Downloader : ObservableObject {
    func downloadImage(imageUrlStr: String) {
        imageUrlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
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


