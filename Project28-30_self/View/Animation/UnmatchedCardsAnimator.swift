//
//  UnmatchedCardsAnimator.swift
//  Project28-30_self
//
//  Created by Fauzan Dwi Prasetyo on 27/05/23.
//

import UIKit

class UnmatchedCardsAnimator {
    
    private static let flipDuration = 0.3
    private static let waitDuration = 1.0
    
    private var flipToFrontAnimator: UIViewPropertyAnimator?
    private var flipToBackAnimator: UIViewPropertyAnimator?
    private var waiter: DispatchWorkItem?
    
    func start(firstCell: CardCell, secondCell: CardCell, completion: (() -> ())? = nil) {
        flipToFront(firstCell: firstCell, secondCell: secondCell, completion: completion)
    }
    
    func cancel() {
        waiter?.cancel()
        waiter = nil
        
        flipToFrontAnimator?.stopAnimation(true)
        flipToFrontAnimator = nil
        
        flipToBackAnimator?.stopAnimation(true)
        flipToBackAnimator = nil
    }
    
    func forceFlipToBack(firstCell: CardCell, secondCell: CardCell) {
        cancel()
        flipToBack(firstCell: firstCell, secondCell: secondCell)
    }
    
    private func flipToFront(firstCell: CardCell, secondCell: CardCell, completion: (() -> ())? = nil) {
        flipToFrontAnimator = UIViewPropertyAnimator(duration: UnmatchedCardsAnimator.flipDuration, timingParameters: UICubicTimingParameters())
        
        flipToFrontAnimator?.addAnimations {
            secondCell.animateFlipTo(state: .front)
        }
        
        flipToFrontAnimator?.addCompletion({ [weak self] _ in
            self?.wait(firstCell: firstCell, secondCell: secondCell, completion: completion)
            self?.flipToFrontAnimator = nil
        })
        
        flipToFrontAnimator?.startAnimation()
    }
    
    private func wait(firstCell: CardCell, secondCell: CardCell, completion: (() -> ())? = nil) {
        waiter = DispatchWorkItem { [weak self] in
            self?.flipToBack(firstCell: firstCell, secondCell: secondCell, completion: completion)
            self?.waiter = nil
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + UnmatchedCardsAnimator.waitDuration, execute: waiter!)
    }
    
    private func flipToBack(firstCell: CardCell, secondCell: CardCell, completion: (() -> ())? = nil) {
        flipToBackAnimator = UIViewPropertyAnimator(duration: UnmatchedCardsAnimator.flipDuration, timingParameters: UICubicTimingParameters())
        
        flipToBackAnimator?.addAnimations {
            firstCell.animateFlipTo(state: .back)
            secondCell.animateFlipTo(state: .back)
        }
        
        flipToBackAnimator?.addCompletion({ [weak self] position in
            self?.flipToBackAnimator = nil
            if position == .end {
                completion?()
            }
        })
        
        flipToBackAnimator?.startAnimation()
    }
}
