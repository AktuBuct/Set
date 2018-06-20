//
//  Card.swift
//  Set
//
//  Created by Evgeniy Ziangirov on 14/06/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import Foundation

struct Card {
    
    let number: Number
    let symbol: Symbol
    let shade: Shade
    let color: Color
    
    enum Number: Int {
        case one, two, three
        var description: String { return String(rawValue + 1) }
        static let all = [Number.one, .two, .three]
    }
    enum Symbol: String {
        case triangle, circle, square
        var description: String { return rawValue }
        static let all = [Symbol.triangle, .circle, .square]
    }
    enum Shade: String {
        case striped, filled, outline
        var description: String { return rawValue }
        static let all = [Shade.striped, .filled, .outline]
    }
    enum Color: String {
        case red, green, purple
        var description: String { return rawValue }
        static let all = [Color.red, .green, .purple]
    }
}

extension Card: Equatable {
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return  lhs.number == rhs.number &&
                lhs.symbol == rhs.symbol &&
                lhs.shade == rhs.shade &&
                lhs.color == rhs.color
    }
}
extension Card {
    var description: String {
        return "\(number.rawValue) \(symbol.rawValue) \(shade.rawValue) \(color.rawValue)\n"
    }
}

