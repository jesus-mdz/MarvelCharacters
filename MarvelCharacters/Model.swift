//
//  Model.swift
//  MarvelCharacters
//
//  Created by Jesus Mendoza on 8/2/21.
//

import Foundation
import UIKit

enum DataError: Error {
    case dataError
}

class Model<Character> {
    var characters: [MarvelCharacter?]
    
    init() {
        characters = [MarvelCharacter?]()
    }
}
