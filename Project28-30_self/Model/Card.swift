//
//  Card.swift
//  Project28-30_self
//
//  Created by Fauzan Dwi Prasetyo on 27/05/23.
//

import Foundation

enum CardState {
    case front
    case back
    case matched
    case complete
}

class Card {
    var state: CardState = .back
    
    var frontImage: String
    var backImage: String
    
    init(frontImage: String, backImage: String) {
        self.frontImage = frontImage
        self.backImage = backImage
    }
}
