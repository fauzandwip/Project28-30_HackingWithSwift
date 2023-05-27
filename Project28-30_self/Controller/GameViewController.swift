//
//  ViewController.swift
//  Project28-30_self
//
//  Created by Fauzan Dwi Prasetyo on 27/05/23.
//

import UIKit

class GameViewController: UICollectionViewController {
    
    var cards = [Card]()
    var flippedCards = [(positon: Int, card: Card)]()

    var cardSize: CardSize!
    
    var cardsDirectory = "Cards.bundle/"
    var currentCards = "Blocks"
    
    var currentCardSize: CGSize!
    
    var flipAnimator = FlipCardAnimator()
    var unmatchedCardsAnimator = UnmatchedCardsAnimator()
    var matchedCardsAnimators = [MatchedCardsAnimator]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Match Pairs"
        
        cardSize = CardSize(imageSize: CGSize(width: 50, height: 50), gridSide1: 3, gridSide2: 4)
        
        loadCards()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateCardSize()
    }
    
    func updateCardSize() {
        collectionView.collectionViewLayout.invalidateLayout()
        
        for cell in collectionView.visibleCells {
            if let cell = cell as? CardCell {
                cell.updateAfterRotate()
            }
        }
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
        guard let size = UIImage(named: backImage!)?.size else { fatalError("Can't get image size") }
        cardSize.imageSize = size
        
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
    
    func matchedCards() {
        guard let (firstCard, firstCell) = getFlippedCard(at: 0) else { return }
        guard let (secondCard, secondCell) = getFlippedCard(at: 1) else { return }
        
        firstCard.state = .matched
        secondCard.state = .matched
        
        let animator = MatchedCardsAnimator()
        matchedCardsAnimators.append(animator)
        
        animator.start(firstCell: firstCell, secondCell: secondCell) { [weak self] in
            self?.matchedCardsAnimators.removeAll(where: { $0 === animator })
            self?.resetFlippedCards()
        }
    }
    
    func unmatchedCards() {
        guard let (firstCard, firstCell) = getFlippedCard(at: 0) else { return }
        guard let (secondCard, secondCell) = getFlippedCard(at: 1) else { return }
        
        firstCard.state = .back
        secondCard.state = .back
        
        unmatchedCardsAnimator.start(firstCell: firstCell, secondCell: secondCell) { [weak self] in
            self?.resetFlippedCards()
        }
    }
    
    func getFlippedCard(at index: Int) -> (Card, CardCell)? {
        let (position, card) = flippedCards[index]
        
        let indexPath = IndexPath(item: position, section: 0)
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell else {
            print("Get card error")
            return nil
        }
        
        return (card, cell)
    }
    
    func resetFlippedCards() {
        flippedCards.removeAll(keepingCapacity: true)
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
//        cell.layer.borderColor = UIColor.black.cgColor
//        cell.layer.borderWidth = 1
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension GameViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell else { return }
        
        let card = cards[indexPath.item]
        guard card.state == .back else { return }
        
        card.state = .front
        
        if flippedCards.isEmpty {
            flipAnimator.flipTo(state: .back, cell: cell)
            flippedCards.append((positon: indexPath.item, card: card))
            return
        }
        
        if flippedCards.count == 1 {
            flippedCards.append((positon: indexPath.item, card: card))
            
            if flippedCards[0].card.frontImage == flippedCards[1].card.frontImage {
                matchedCards()
            } else {
                unmatchedCards()
            }
            return
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension GameViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        currentCardSize = cardSize.getCardSize(collectionView: collectionView)
        
        return currentCardSize
    }
}


