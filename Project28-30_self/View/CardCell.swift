//
//  CardCell.swift
//  Project28-30_self
//
//  Created by Fauzan Dwi Prasetyo on 27/05/23.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    var front: UIImageView!
    var back: UIImageView!
    
    var card: Card?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        build()
    }
    
    func set(card: Card) {
        self.card = card
        front.image = UIImage(named: card.frontImage)
        back.image = UIImage(named: card.backImage)
        
        reset(state: card.state)
    }
    
    fileprivate func build() {
        let sizeWidth = frame.size.width
        let sizeHeight = frame.size.height
        
        front = UIImageView(frame: CGRect(x: 0, y: 0, width: sizeWidth, height: sizeHeight))
        front.contentMode = .scaleAspectFit
        front.isHidden = true
        
        back = UIImageView(frame: CGRect(x: 0, y: 0, width: sizeWidth, height: sizeHeight))
        back.contentMode = .scaleAspectFit
//        back.isHidden = true
        
        addSubview(front)
        addSubview(back)
    }
    
    fileprivate func reset(state: CardState) {
        cancelAnimations()
        
        var flipTarget: CardState
        var scaleFactor: CGFloat
        
        updateImageSize()
        
        switch state {
        case .back:
            flipTarget = .back
            scaleFactor = 1
        case .front:
            flipTarget = .front
            scaleFactor = 1
        case .matched:
            flipTarget = .front
            scaleFactor = 1
        case .complete:
            flipTarget = .front
            scaleFactor = 1
        }
        
        animateFlipTo(state: flipTarget)
        DispatchQueue.main.async { [weak self] in
            self?.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        }
    }
    
    func updateImageSize() {
        let sizeWidth = frame.size.width
        let sizeHeight = frame.size.height
        
        front.frame = CGRect(x: 0, y: 0, width: sizeWidth, height: sizeHeight)
        back.frame = CGRect(x: 0, y: 0, width: sizeWidth, height: sizeHeight)
    }
    
    func updateAfterRotateOrResize() {
        DispatchQueue.main.async { [weak self] in
            self?.updateImageSize()
        }
        
        if card?.state == .matched {
            DispatchQueue.main.async { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            }
        }
    }
    
    func animateFlipTo(state: CardState) {
        guard state == .front || state == .back else { fatalError("Can only flip to front or back") }
        
        let from: UIView, to: UIView
        let transition: AnimationOptions
        
        if state == .front {
            guard getFacingSide() == .back else { return }
            from = back
            to = front
            transition = .transitionFlipFromRight
        } else {
            guard getFacingSide() == .front else { return }
            from = front
            to = back
            transition = .transitionFlipFromLeft
        }
        
        UIView.transition(from: from, to: to, duration: 0, options: [transition, .showHideTransitionViews])
    }
    
    func animateMatch() {
        transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
    }
    
    func animateCompleteGame() {
        transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    fileprivate func cancelAnimations() {
        layer.removeAllAnimations()
        front.layer.removeAllAnimations()
        back.layer.removeAllAnimations()
    }
    
    fileprivate func getFacingSide() -> CardState {
        if back.isHidden {
            return .front
        }
        
        return .back
    }
}
