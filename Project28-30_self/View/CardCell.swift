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
        
    }
    
    fileprivate func build() {
        let sizeWidth = frame.size.width
        let sizeHeight = frame.size.height
        
        front = UIImageView(frame: CGRect(x: 0, y: 0, width: sizeWidth, height: sizeHeight))
        front.contentMode = .scaleAspectFit
//        front.isHidden = true
        
        back = UIImageView(frame: CGRect(x: 0, y: 0, width: sizeWidth, height: sizeHeight))
        back.contentMode = .scaleAspectFit
        back.isHidden = true
        
        addSubview(front)
        addSubview(back)
    }
}
