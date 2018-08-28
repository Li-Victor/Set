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
    private(set) var number: CardNumber
    private(set) var symbol: CardSymbol
    private(set) var shading: CardShading
    private(set) var color: CardColor
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.number == rhs.number && lhs.symbol == rhs.symbol && lhs.shading == rhs.shading && lhs.color == rhs.color
    }
    
    func makesSetWith(_ firstCard: Card, _ secondCard: Card) -> Bool {
        return numberCondition(self, firstCard, secondCard) && symbolCondition(self, firstCard, secondCard) && shadingCondition(self, firstCard, secondCard) && colorCondition(self, firstCard, secondCard)
        // return true
    }
    
    private func numberCondition(_ firstCard: Card, _ secondCard: Card, _ thirdCard: Card) -> Bool {
        return (firstCard.number == secondCard.number && firstCard.number == thirdCard.number && secondCard.number == thirdCard.number)
            || (firstCard.number != secondCard.number && firstCard.number != thirdCard.number && secondCard.number != thirdCard.number)
    }
    
    private func symbolCondition(_ firstCard: Card, _ secondCard: Card, _ thirdCard: Card) -> Bool {
        return (firstCard.symbol == secondCard.symbol && firstCard.symbol == thirdCard.symbol && secondCard.symbol == thirdCard.symbol)
            || (firstCard.symbol != secondCard.symbol && firstCard.symbol != thirdCard.symbol && secondCard.symbol != thirdCard.symbol)
    }
    
    private func shadingCondition(_ firstCard: Card, _ secondCard: Card, _ thirdCard: Card) -> Bool {
        return (firstCard.shading == secondCard.shading && firstCard.shading == thirdCard.shading && secondCard.shading == thirdCard.shading)
            || (firstCard.shading != secondCard.shading && firstCard.shading != thirdCard.shading && secondCard.shading != thirdCard.shading)
    }
    
    private func colorCondition(_ firstCard: Card, _ secondCard: Card, _ thirdCard: Card) -> Bool {
        return (firstCard.color == secondCard.color && firstCard.color == thirdCard.color && secondCard.color == thirdCard.color)
            || (firstCard.color != secondCard.color && firstCard.color != thirdCard.color && secondCard.color != thirdCard.color)
    }
    
    init(number: CardNumber, symbol: CardSymbol, shading: CardShading, color: CardColor) {
        self.number = number
        self.symbol = symbol
        self.shading = shading
        self.color = color
    }
}
