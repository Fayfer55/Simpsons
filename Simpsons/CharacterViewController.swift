//
//  CharacterViewController.swift
//  Simpsons
//
//  Created by Кирилл Файфер on 22.09.2020.
//

import UIKit

class CharacterViewController: UIViewController {
    @IBOutlet var characterImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var qouteLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private let url = "https://thesimpsonsquoteapi.glitch.me/quotes"
    private var character: [CharacterModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        NetworkManager.shared.fetchData(from: url) { characterModel in
            self.character = characterModel
            
            self.setCharacter()
        }
    }
    
    @IBAction func getNewCharacterButton() {
        NetworkManager.shared.fetchData(from: url) { characterModel in
            self.character = characterModel
        }
        setCharacter()
    }
    
    private func setCharacter() {
        guard let characterModel = self.character else { return }
        
        for character in characterModel {
            print(character)
            self.nameLabel.text = character.character
            self.qouteLabel.text = character.quote
            
            DispatchQueue.global().async {
                guard let image = ImageManager.shared.fetchImage(from: character.image) else { return }
                DispatchQueue.main.async {
                    self.characterImageView.image = UIImage(data: image)
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}

