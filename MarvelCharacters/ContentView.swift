//
//  ContentView.swift
//  MarvelCharacters
//
//  Created by Jesus Mendoza on 8/2/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            CardGrid(characters: viewModel.characters!)
        }
        .padding([.top, .leading, .trailing])
        .task {
            print("THESE ARE THE CHARACTERS IN VIEW")
            print(viewModel.characters)
        }
    }
}

struct CardGrid: View {
    var characters: [MarvelCharacter?]
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 500))]) {
                    ForEach(characters, id: \.self) { character in
                        CharacterCard(character: character!)
                    }
                }
            }
        }
    }
}

struct CharacterCard: View {
    let character: MarvelCharacter?
    let rectangle = RoundedRectangle(cornerRadius: 18)

    var body: some View {
        VStack {
            AsyncImage(
                url:
                    URL(string: "\((character?.thumbnail?.path)!).\((character?.thumbnail?.extension)!)"),
                content: { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fit)
                         .frame(maxWidth: 400, maxHeight: 400)
                },
                placeholder: {
                    ProgressView()
                }
            )
            ZStack {
                rectangle
                    .foregroundColor(.gray)
                    .frame(width: 330, height: 470)
                VStack(alignment: .leading) {
                    Text("Name:")
                        .fontWeight(.heavy)
                    Text((character?.name)!)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom)
                    Text("Description:")
                        .fontWeight(.heavy)
                    Text((character?.description)!)
                        .font(.body)
                        .padding(.bottom)
                }
                .foregroundColor(Color.white)
                .padding()
            }
        }
        .padding(50)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModel()
        ContentView(viewModel: viewModel)
            .preferredColorScheme(.light)
    }
}
