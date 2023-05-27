//
//  CompletionAnimator.swift
//  Project28-30_self
//
//  Created by Fauzan Dwi Prasetyo on 27/05/23.
//

import UIKit

class CompletionAnimator {
    
    static let betweenCardsDelay = 0.05
    static let completeDuration = 1.0
    
    var animators = [UIViewPropertyAnimator]()
    var worker: DispatchWorkItem?
    
    func start(cards: [Card], collectionView: UICollectionView, completion: (() -> ())? = nil) {
        complete(cards: cards, collectionView: collectionView)
    }
    
    func cancel() {
        worker?.cancel()
        
        for animator in animators {
            animator.stopAnimation(true)
        }
    }
    
    func complete(cards: [Card], collectionView: UICollectionView, completion: (() -> ())? = nil) {
        worker = DispatchWorkItem { [weak self] in
            var delay: TimeInterval = 0
            
            for i in 0..<cards.count {
                
                if (self?.worker?.isCancelled ?? false) { return }
                
                let indexPath = IndexPath(item: i, section: 0)
                guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell else { continue }
                
                let springTiming = UISpringTimingParameters(dampingRatio: 0.25, initialVelocity: CGVector(dx: 5, dy: 5))
                let animator = UIViewPropertyAnimator(duration: CompletionAnimator.completeDuration, timingParameters: springTiming)
                
                animator.addAnimations {
                    cell.animateCompleteGame()
                }
                
                animator.addCompletion { [weak self] _ in
                    self?.animators.removeAll(where: { $0 === animator })
                }
                
                self?.animators.append(animator)
                
                animator.startAnimation(afterDelay: delay)
                
                delay += CompletionAnimator.betweenCardsDelay
            }
        }
        
        worker?.perform()
    }
}
