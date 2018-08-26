//
//  Set.swift
//  Set
//
//  Created by Victor Li on 8/25/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import Foundation

struct Set {
    private(set) var playingCards: [Card] = []
    private(set) var deck: [Card] = []
    private(set) var matchedCards: [Card] = []
    
    private func getSelectedCards() -> [Card] {
        return playingCards.filter { $0.selected }
    }
    
    private func checkMatching(cards: [Card]) -> Bool {
        return true
    }
    
    mutating func threeNewCards() -> (Card, Card, Card) {
        assert(playingCards.count == 0, "threeNewCards function: There cannot be three new cards when there are no more cards in the deck")
        return (playingCards.removeFirst(), playingCards.removeFirst(), playingCards.removeFirst())
    }
    
    mutating func replace(cards: [Card]) {
        guard cards.count == 3 else {
            print("There are not 3 selected cards")
            return
        }
        
        // get indexes of selected cards
        let firstIndex = playingCards.index { $0 == cards[0] }!
        let secondIndex = playingCards.index { $0 == cards[1] }!
        let thirdIndex = playingCards.index { $0 == cards[2] }!
        
        guard deck.count > 0 else {
            playingCards[firstIndex].matched = true
            playingCards[secondIndex].matched = true
            playingCards[thirdIndex].matched = true
            return
        }
        
        let (firstNewCard, secondNewCard, thirdNewCard) = threeNewCards()
        playingCards[firstIndex] = firstNewCard
        playingCards[secondIndex] = secondNewCard
        playingCards[thirdIndex] = thirdNewCard
        
        // set matched and put those the three cards into matchCards
        
    }
    
    // deselect or select card
    mutating func chooseCard(at index: Int) {
        let selectedCards = getSelectedCards()
        
        
        
        // selected
        if playingCards[index].selected {
            
            if selectedCards.count == 1 || selectedCards.count == 2 {
                // deselecting
                playingCards[index].selected = false
                return
            }
            
        } else {
            // choosing a non-selected card and there are already 3 selected cards
            if selectedCards.count == 3 {
                if checkMatching(cards: selectedCards) {
                    // replace the three selected cards
                    replace(cards: selectedCards)
                } else {
                    // the 3 selected cards are not matched
                    for i in playingCards.indices {
                        playingCards[i].selected = false
                    }
                }
            }
            playingCards[index].selected = true
        }
    }
    
    func deal3MoreCards() {
//        if matched() {
//            // replace the playingCards matched
//            // put those three cards into matchedCards
//        } else {
//            // take 3 cards from the deck and put into playingCards
//        }
    }
    
    mutating func reset() {
        // put matchedCards and playingCards in deck
        deck.append(contentsOf: matchedCards)
        deck.append(contentsOf: playingCards)
        matchedCards.removeAll()
        playingCards.removeAll()
        
        for i in deck.indices {
            deck[i].matched = false
        }
        
        // shuffle
        // deck.shuffle()
        
        for _ in 1...12 {
            disperseToPlayingCards()
        }
    }
    
    mutating func disperseToPlayingCards() {
        let onecard = deck.removeFirst()
        matchedCards.append(onecard)
    }
    
    init(numbers: [Int], symbols: [String], shadings: [String], colors: [String]) {
        // Make 81 Cards at deck
        
        for number in numbers {
            for symbol in symbols {
                for shading in shadings {
                    for color in colors {
                        deck.append(Card(number: number, symbol: symbol, shading: shading, color: color))
                    }
                }
            }
        }
        
        self.reset()
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

extension Array {
    mutating func shuffle() {
        for i in stride(from: self.count - 1, to: 1, by: -1) {
            let random = i.arc4random
            self.swapAt(i, random)
        }
    }
}
