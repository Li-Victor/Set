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

    private func checkMatchingFrom(firstCard: Card, secondCard: Card, thirdCard: Card) -> Bool {
//        return numberCondition(firstCard, secondCard, thirdCard) && symbolCondition(firstCard, secondCard, thirdCard)
//            && shadingCondition(firstCard, secondCard, thirdCard) && colorCondition(firstCard, secondCard, thirdCard)
        return true
    }

    func getMatchingCards() -> [Card] {
        let matched = matchedCards
        let matchedPlayingCards = playingCards.filter { $0.matched }
        return matched + matchedPlayingCards
    }

    mutating func threeNewCards() -> (Card, Card, Card) {
        assert(playingCards.count == 0, "threeNewCards function: There cannot be three new cards when there are no more cards in the deck")
        return (playingCards.removeFirst(), playingCards.removeFirst(), playingCards.removeFirst())
    }

    mutating func replace(cards: [Card]) {
        guard cards.count == 3 else {
            print("There has to be 3 selected cards")
            return
        }

        // get indexes of selected cards
        let firstIndex = playingCards.index { $0 == cards[0] }!
        let secondIndex = playingCards.index { $0 == cards[1] }!
        let thirdIndex = playingCards.index { $0 == cards[2] }!

        playingCards[firstIndex].matched = true
        playingCards[secondIndex].matched = true
        playingCards[thirdIndex].matched = true

        // set matched and put those the three cards into matchCards
        guard deck.count > 0 else {
            return
        }

        matchedCards.append(contentsOf: [playingCards[firstIndex], playingCards[secondIndex], playingCards[thirdIndex]])
        let (firstNewCard, secondNewCard, thirdNewCard) = threeNewCards()
        playingCards[firstIndex] = firstNewCard
        playingCards[secondIndex] = secondNewCard
        playingCards[thirdIndex] = thirdNewCard
    }

    // deselect or select card
    mutating func chooseCard(at index: Int) {
        let selectedCards = getSelectedCards()

        if playingCards[index].selected {
            // deselecting
            if selectedCards.count == 1 || selectedCards.count == 2 {

                playingCards[index].selected = false
                return
            }
            // if selected count is 3, nothing goes on

        } else {
            // choosing a non-selected card and there are already 3 selected cards
            if selectedCards.count == 3 {
                if checkMatchingFrom(firstCard: selectedCards[0], secondCard: selectedCards[1], thirdCard: selectedCards[2]) {
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

    mutating func deal3MoreCards() {
        let selectedCards = getSelectedCards()
        if selectedCards.count == 3, checkMatchingFrom(firstCard: selectedCards[0], secondCard: selectedCards[1], thirdCard: selectedCards[2]) {
            // replace the playingCards that are matched
            replace(cards: selectedCards)
        } else {
            // take 3 cards from the deck and put into playingCards
            for _ in 1...3 {
                disperseToPlayingCards()
            }
        }
    }

    mutating func reset() {
        // put matchedCards and playingCards in deck
        deck.append(contentsOf: matchedCards)
        deck.append(contentsOf: playingCards)
        matchedCards.removeAll()
        playingCards.removeAll()

        for i in deck.indices {
            deck[i].matched = false
            deck[i].selected = false
        }
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
        return Int(arc4random_uniform(UInt32(self)))
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