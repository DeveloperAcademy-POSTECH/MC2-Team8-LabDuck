//
//  KPTagColor.swift
//  LabDuck
//
//  Created by hanseoyoung on 5/18/24.
//

import Foundation
import SwiftUI

enum KPTagColor: String, CaseIterable, Codable {
    case orange
    case yellow
    case green
    case blue
    case purple
    case pink
    case brown
    case gray
    case `default`
    
    var backgroundColor: Color {
        switch self {
        case .orange:
            return Color(.systemOrange)
        case .yellow:
            return Color(.systemYellow)
        case .green:
            return Color(.systemGreen)
        case .blue:
            return Color(.systemBlue)
        case .purple:
            return Color(.systemPurple)
        case .pink:
            return Color(.systemPink)
        case .brown:
            return Color(.systemBrown)
        case .gray:
            return Color(.systemGray)
        case .`default`:
            return Color(.systemCyan)
        }
    }
}

extension KPTagColor {
    static func random() -> KPTagColor {
        return KPTagColor.allCases.randomElement()!
    }
}

