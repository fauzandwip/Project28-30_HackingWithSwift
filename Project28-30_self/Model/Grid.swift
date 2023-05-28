//
//  Grid.swift
//  Project28-30_self
//
//  Created by Fauzan Dwi Prasetyo on 27/05/23.
//

import Foundation

class Grid {
    
    var numberOfElements: Int
    var combinations: [(Int, Int)]
    
    init(numberOfElements: Int, combinations: [(Int, Int)]) {
        self.numberOfElements = numberOfElements
        self.combinations = combinations
    }
}
