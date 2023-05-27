//
//  MatchedCardsAnimation.swift
//  Project28-30_self
//
//  Created by Fauzan Dwi Prasetyo on 27/05/23.
//

import UIKit

class MatchedCardsAnimator {
    
    static let flipDuration = 0.3
    static let matchDuration = 1.0
    
    var flipToFrontAnimator: UIViewPropertyAnimator?
    var matchAnimator: UIViewPropertyAnimator?
    
    func start(firstCell: CardCell, secondCell: CardCell, completion: (() -> ())? = nil) {
        flipToFront(firstCell: firstCell, secondCell: secondCell, completion: completion)
    }
    
    func cancel() {
        flipToFrontAnimator?.stopAnimation(true)
        flipToFrontAnimator = nil
        
        matchAnimator?.stopAnimation(true)
        matchAnimator = nil
    }
    
    private func flipToFront(firstCell: CardCell, secondCell: CardCell, completion: (() -> ())? = nil) {
        flipToFrontAnimator = UIViewPropertyAnimator(duration: MatchedCardsAnimator.flipDuration, curve: .linear)
        
        flipToFrontAnimator?.addAnimations {
            secondCell.animateFlipTo(state: .front)
        }
        
        flipToFrontAnimator?.addCompletion({ [weak self] _ in
            self?.match(firstCell: firstCell, secondCell: secondCell, completion: completion)
            self?.flipToFrontAnimator = nil
        })
        
        flipToFrontAnimator?.startAnimation()
    }
    
    private func match(firstCell: CardCell, secondCell: CardCell, completion: (() -> ())? = nil) {
        let springTiming = UISpringTimingParameters(dampingRatio: 0.25, initialVelocity: CGVector(dx: 5, dy: 5))
        matchAnimator = UIViewPropertyAnimator(duration: MatchedCardsAnimator.matchDuration, timingParameters: springTiming)
        
        matchAnimator?.addAnimations {
            firstCell.animateMatch()
            secondCell.animateMatch()
        }
        
        matchAnimator?.addCompletion({ [weak self] _ in
            self?.matchAnimator = nil
            completion?()
        })
        
        matchAnimator?.startAnimation()
    }
}
