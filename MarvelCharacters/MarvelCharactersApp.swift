//
//  MarvelCharactersApp.swift
//  MarvelCharacters
//
//  Created by Jesus Mendoza on 8/2/21.
//

import SwiftUI

@main
struct MarvelCharactersApp: App {
    let viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
