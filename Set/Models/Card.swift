//
//  Card.swift
//  Set
//
//  Created by Victor Li on 8/25/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import Foundation
struct Card: Equatable {
    var matched = false
    var selected = false
    private(set) var number: Int
    private(set) var symbol: String
    private(set) var shading: String
    private(set) var color: String
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.number == rhs.number && lhs.symbol == rhs.symbol && lhs.shading == rhs.shading && lhs.color == rhs.color
    }
    
    init(number: Int, symbol: String, shading: String, color: String) {
        self.number = number
        self.symbol = symbol
        self.shading = shading
        self.color = color
    }
}
