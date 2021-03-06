//
//  CardDeck.swift
//  Set
//
//  Created by Evgeniy Ziangirov on 14/06/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import Foundation

struct CardDeck {

    private(set) var cards = [Card]()
    
    init() {
        for number in Card.Number.all {
            for symbol in Card.Symbol.all {
                for shade in Card.Shade.all {
                    for color in Card.Color.all {
                        cards.append(Card(number: number,
                                          symbol: symbol,
                                          shade: shade,
                                          color: color))
                    }
                }
            }
        }
        cards.shuffle()
    }
    
    mutating func deal() -> Card? {
        if cards.count > 0 {
            return cards.removeLast()
        } else {
            return nil
        }
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
        for index in stride(from: count - 1, through: 1, by: -1) {
            let randomIndex = (index + 1).arc4random
            if index != randomIndex {
                self.swapAt(index, randomIndex)
            }
        }
    }
}
