//
//  ViewModel.swift
//  MarvelCharacters
//
//  Created by Jesus Mendoza on 8/2/21.
//

import Foundation
import CryptoSwift
import Combine

class ViewModel: ObservableObject {
//    private var model: Model<String> = Model<String>()
    @Published var characters: [MarvelCharacter]? = []
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getCharacters()
    }
    
    func getCharacters() {
        let url = getCharactersURL()
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300 else {
                        throw URLError(URLError.badServerResponse)
                    }
                print(data)
                return data
            }
            .decode(type: ResponseWrapper?.self, decoder: JSONDecoder())
            .sink { (completion) in
                print("COMPLETION: \(completion)")
            } receiveValue: { [weak self]
                (returnedCharacters) in
                print("hello",returnedCharacters)
                let responseWrapper = returnedCharacters
                self?.characters = responseWrapper?.data?.results
            }
            .store(in: &cancellables)
        
        print("AFTER GETCHARACTERS IS RUN")
        print(characters)
    }

//    func setCharacters() async -> Void {
//        await model.setCharacters()
//    }

//    var characters: [MarvelCharacter?] {
//        return model.characters
//    }
}

// Used to encode/decode API data to a specific model
struct MarvelCharacter: Codable {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: Image?
}

struct ResponseWrapper: Codable {
    let data: CharacterResponse?
}

struct CharacterResponse: Codable {
    let results: [MarvelCharacter]?
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

func getCharactersURL() -> URL {
    let publicKey = "0d1a3f2a73ac95a9dedafb02e2766fa1"
    let privateKey = "2fd31648df109a599c32d1ff0ca441b51790cd82"
    let timestamp = getNewDate()
    let hash = getHashValue(
        timestamp: timestamp,
        privateKey: privateKey,
        publicKey: publicKey)
    let url = URL(string: "https://gateway.marvel.com:443/v1/public/characters?orderBy=name&limit=10&ts=\(timestamp)&apikey=\(publicKey)&hash=\(hash)")!
    return url
}

func getHashValue(timestamp: String, privateKey: String, publicKey: String) -> String {
    "\(timestamp)\(privateKey)\(publicKey)".md5()
}

func getNewDate() -> String {
    return Date().timeIntervalSince1970.description
}

struct Image: Codable, Equatable {
    let path: String?
    let `extension`: String?
}

extension MarvelCharacter: Hashable {
    static func == (lhs: MarvelCharacter, rhs: MarvelCharacter) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.description == rhs.description && lhs.thumbnail == rhs.thumbnail
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(description)
    }
}
