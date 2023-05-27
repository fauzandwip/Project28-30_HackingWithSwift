//
//  File.swift
//  Project28-30_self
//
//  Created by Fauzan Dwi Prasetyo on 27/05/23.
//

import UIKit

class FlipCardAnimator {
    static let flipDuration = 0.3
    
    var flipAnimator: UIViewPropertyAnimator?
    
    func cancel() {
        flipAnimator?.stopAnimation(true)
        flipAnimator = nil
    }
    
    func flipTo(state: CardState, cell: CardCell) {
        flipAnimator = UIViewPropertyAnimator(duration: FlipCardAnimator.flipDuration, curve: .linear)
        
        flipAnimator?.addAnimations {
            cell.animateFlipTo(state: .front)
        }
        
        flipAnimator?.addCompletion({ [weak self] _ in
            self?.flipAnimator = nil
        })
        
        flipAnimator?.startAnimation()
    }
}
