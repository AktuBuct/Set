//
//  Game.swift
//  Set
//
//  Created by Evgeniy Ziangirov on 14/06/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import Foundation

struct Game {
    
    private var deck = CardDeck()
    var deckCount: Int { return deck.cards.count }
    
    private(set) var score = 0
    
    private(set) var cardsOnTable = [Card]()
    private(set) var cardsSelected = [Card]()
    private(set) var cardsSets = [[Card]]()
    
    private(set) lazy var cardsHints = [Card]()
    
    private var isSet: Bool? {
        get {
            guard cardsSelected.count == 3 else { return nil }
            return cardsSelected.isSet()
        }
        set {
            if newValue != nil {
                switch newValue! {
                case true:
                    cardsSets.append(cardsSelected)
                    replaceOrRemoveCard()
                    cardsSelected.removeAll()
                    score += Score.bonus.rawValue
                case false:
                    cardsSelected.removeAll()
                    score += Score.penalty.rawValue
                }
            } else { cardsSelected.removeAll() }
        }
    }

    mutating func chooseCard(at index: Int) {
        assert(cardsOnTable.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        
        let choosenCard = cardsOnTable[index]
        
        switch cardsSelected {
        case let cardsForSet where cardsForSet.count == 3: isSet = isSet
        case let cardsForSet where !cardsForSet.contains(choosenCard): cardsSelected.append(choosenCard)
        default:
            cardsSelected = cardsSelected.filter() { $0 != choosenCard }
        }
    }

    private mutating func replaceOrRemoveCard() {
        for cardSelected in cardsSelected {
            let indexForChange = cardsOnTable.index(of: cardSelected)
            if cardsOnTable.count <= 12, let card = deck.deal() {
                cardsOnTable[indexForChange!] = card
            } else {
                cardsOnTable.remove(at: indexForChange!)
            }
        }
    }
    
    mutating func hint() {
        cardsSelected.removeAll()
        score += Score.hint.rawValue
        cardsHints = cardsOnTable.returnThripletFor() { $0.isSet() }
    }
    mutating func dealThreeOnTable() {
        repeatBy(3) { deal() }
    }
    mutating func isEnd() -> Bool {
        return cardsOnTable.returnThripletFor() { $0.isSet() }.isEmpty
    }
    mutating func reset() {
        self = Game.init()
    }
    init() {
        repeatBy(12) { deal() }
    }
}

private extension Game {
    enum Score: Int {
        case bonus = 3, penalty = -5, hint = -2
    }
    mutating func deal() {
        if let card = deck.deal() {
            cardsOnTable.append(card)
        }
    }
    func repeatBy(_ repeatingCount: Int, closure: ()->()) {
        guard repeatingCount > 0 else { return }
        for _ in 1...repeatingCount { closure() }
    }
}

private extension Array where Element == Card {
    func isSet() -> Bool {
        let number  = Set(self.map { $0.number } )
        let symbol  = Set(self.map { $0.symbol } )
        let shade   = Set(self.map { $0.shade } )
        let color   = Set(self.map { $0.color } )
        
        return  number.count != 2 && symbol.count != 2 && shade.count != 2 && color.count != 2
    }
}
private extension Array where Element: Equatable {
    func returnThripletFor(_ closure: (_ check: [Element]) -> (Bool)) -> [Element] {
        for i in 0..<self.count  {
            for j in (i + 1)..<self.count {
                for k in (j + 1)..<self.count {
                    let result = [self[i],self[j],self[k]]
                    if closure(result) {
                        return result
                    }
                }
            }
        }
        return []
    }
}
