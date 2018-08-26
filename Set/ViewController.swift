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
    private lazy var SetGame = setupGame()
    
    func setupGame() -> [Card] {
        var cards = [Card]()
        for number in CardNumber.all {
            for symbol in CardSymbol.all {
                for shading in CardShading.all {
                    for color in CardColor.all {
                        cards.append(Card(number: number, symbol: symbol, shading: shading, color: color))
                    }
                }
            }
        }
        return cards
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
