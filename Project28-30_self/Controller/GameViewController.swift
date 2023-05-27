//
//  ViewController.swift
//  Project28-30_self
//
//  Created by Fauzan Dwi Prasetyo on 27/05/23.
//

import UIKit

class GameViewController: UICollectionViewController {
    
    var cards = [Card]()
    
    var cardsDirectory = "Cards.bundle/"
    var currentCards = "Blocks"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Match Pairs"
        
        loadCards()
        collectionView.reloadData()
    }
    
    func loadCards() {
        var backImage: String? = nil
        var frontImages = [String]()
        
        if let urls = Bundle.main.urls(forResourcesWithExtension: nil, subdirectory: cardsDirectory + currentCards) {
            for url in urls {
                if url.lastPathComponent.starts(with: "1\(currentCards)_back.") {
                    backImage = url.path
                } else {
                    frontImages.append(url.path)
                }
            }
        }
        
        guard backImage != nil else { fatalError("No back image found") }
        
        let cardsNumber = 3 * 4
        
        while frontImages.count > cardsNumber / 2 {
            frontImages.remove(at: Int.random(in: 0..<frontImages.count))
        }
        
        while frontImages.count < cardsNumber / 2 {
            frontImages.append(frontImages[Int.random(in: 0..<frontImages.count)])
        }
        
        frontImages += frontImages
        frontImages.shuffle()
        
        for i in 0..<frontImages.count {
            cards.append(Card(frontImage: frontImages[i], backImage: backImage!))
        }
    }
}


// MARK: - UICollectionViewDataSource

extension GameViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dequeuedcell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath)
        
        guard let cell = dequeuedcell as? CardCell else { return dequeuedcell }
        cell.set(card: cards[indexPath.item])
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        
        return cell
    }
}


