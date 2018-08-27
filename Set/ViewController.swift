//
//  ViewController.swift
//  Set
//
//  Created by Victor Li on 8/25/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var Deal3MoreCardsButton: UIButton!
    private lazy var SetGame = setupGame()
    
    @IBAction private func touchCard(_ sender: UIButton) {
        guard let index = cardButtons.index(of: sender) else {
            print("chosen card was not in cardButtons")
            return
        }
        
        guard index < SetGame.playingCards.count else {
            // the index of the card should be within the playing cards count
            return
        }
        
        SetGame.chooseCard(at: index)
        updateViewFromModel()
    }
    
    @IBAction private func touchDeal3MoreCards() {
        guard SetGame.playingCards.count < 24 else {
            print("Deal 3 More Cards Button should be disabled and nothing should happen")
            return
        }
        SetGame.deal3MoreCards()
        updateViewFromModel()
    }
    
    @IBAction private func touchNewGame() {
        
        updateViewFromModel()
    }
    
    private func setupGame() -> Set {
        var deck = [Card]()
        for number in CardNumber.all {
            for symbol in CardSymbol.all {
                for shading in CardShading.all {
                    for color in CardColor.all {
                        deck.append(Card(number: number, symbol: symbol, shading: shading, color: color))
                    }
                }
            }
        }
        return Set(deck: deck)
    }
    
    private func getAttributes(color: CardColor, shading: CardShading) -> [NSAttributedStringKey: Any] {
        
        let attributes: [NSAttributedStringKey: Any]
        
        let uiColor: UIColor
        switch color {
        case .green: uiColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        case .purple: uiColor = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)
        case .red: uiColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
        
        switch shading {
        case .open: attributes = [
            .strokeWidth: 5.0,
            .strokeColor: uiColor
            ]
        case .solid: attributes = [
            .foregroundColor: uiColor.withAlphaComponent(1)
            ]
        case .striped: attributes = [
            .foregroundColor: uiColor.withAlphaComponent(0.15)
            ]
        }
        
        return attributes
    }
    
    private func getAttributedString(_ card: Card) -> NSAttributedString {
        let attributes = getAttributes(color: card.color, shading: card.shading)
        let symbol = card.symbol.rawValue
        let number = card.number.rawValue
        let string = Array(repeating: symbol, count: number).joined(separator: "")
        
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    private func matchingSelectedCards() -> Bool {
        let selectedCards = SetGame.playingCards.filter { $0.selected }
        guard selectedCards.count == 3 else {
            return false
        }
        
        return selectedCards[0].makesSetWith(selectedCards[1], selectedCards[2])
    }
    
    private func updateViewFromModel() {
        var i = 0
        for card in SetGame.playingCards {
            let button = cardButtons[i]
            button.layer.cornerRadius = 8.0
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            let attributedString = getAttributedString(card)
        
            button.setAttributedTitle(attributedString, for: UIControlState.normal)
            
            if card.selected {
                button.layer.borderWidth = 3.0
                button.layer.borderColor = UIColor.blue.cgColor
            } else {
                button.layer.borderWidth = 0.0
                button.layer.borderColor = UIColor.white.cgColor
            }
            i += 1
        }
        
        // enable or disable Deal3MoreCards button
        if (SetGame.playingCards.count < 24 && SetGame.deck.count > 0) || (matchingSelectedCards()) {
            Deal3MoreCardsButton.isEnabled = true
            Deal3MoreCardsButton.backgroundColor = #colorLiteral(red: 0, green: 0.4705882353, blue: 0.7607843137, alpha: 1)
            Deal3MoreCardsButton.setTitleColor(#colorLiteral(red: 0.9098039216, green: 0.9490196078, blue: 0.9725490196, alpha: 1), for: .normal)
        } else {
            Deal3MoreCardsButton.isEnabled = false
            Deal3MoreCardsButton.backgroundColor = #colorLiteral(red: 0.6901960784, green: 0.7882352941, blue: 0.8431372549, alpha: 1)
            Deal3MoreCardsButton.setTitleColor(#colorLiteral(red: 0.8392156863, green: 0.8901960784, blue: 0.9294117647, alpha: 1), for: .normal)
        }
        
        for index in i..<cardButtons.count {
            let button = cardButtons[index]
            button.layer.cornerRadius = 8.0
            button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViewFromModel()
    }

}

enum CardNumber: Int {
    case one = 1
    case two = 2
    case three = 3
    static var all = [CardNumber.one, CardNumber.two, CardNumber.three]
}

enum CardSymbol: String {
    case triangle = "▲"
    case circle = "●"
    case square = "■"
    static var all = [CardSymbol.triangle, CardSymbol.circle, CardSymbol.square]
}

enum CardShading {
    case solid
    case striped
    case open
    static var all = [CardShading.solid, CardShading.striped, CardShading.open]
}

enum CardColor {
    case red
    case green
    case purple
    static var all = [CardColor.red, CardColor.green, CardColor.purple]
}
