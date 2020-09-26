//
//  NetworkManager.swift
//  Simpsons
//
//  Created by Кирилл Файфер on 22.09.2020.
//

import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    //    func fetchData(from url: String, with complition: @escaping ([CharacterModel]) -> Void) {
    //        guard let urlSession = URL(string: url) else { return }
    //
    //        URLSession.shared.dataTask(with: urlSession) { (data, _, error) in
    //            if let error = error {
    //                print(error)
    //            }
    //            guard let data = data else { return }
    //
    //            do {
    //                let character = try JSONDecoder().decode([CharacterModel].self, from: data)
    //                DispatchQueue.main.async {
    //                    complition(character)
    //                }
    //            } catch let error {
    //                print(error)
    //            }
    //        }.resume()
    //    }
    
    func fetchData(from url: String, with complition: @escaping ([CharacterModel]) -> Void) {
        var person: [CharacterModel] = []
        
        AF.request(url)
            .validate()
            .responseJSON { dataResponce in
                switch dataResponce.result {
                case .success(let value):
                    guard let characterData = value as? [[String:Any]] else { return }
                    
                    for character in characterData {
                        let hero = CharacterModel(
                            character: character["character"] as? String,
                            quote: character["quote"] as? String,
                            image: character["image"] as? String
                        )
                        
                        person.append(hero)
                    }
                    DispatchQueue.main.async {
                        complition(person)
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}

class ImageManager {
    static var shared = ImageManager()
    
    func fetchImage(from url: String?) -> Data? {
        guard let stringUrl = url else { return nil }
        guard let imageUrl = URL(string: stringUrl) else { return nil }
        
        return try? Data(contentsOf: imageUrl)
    }
}

