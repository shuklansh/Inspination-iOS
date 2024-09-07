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
