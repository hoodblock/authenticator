//
//  Color+Extension.swift
//  Authenticator
//
//  Created by SZ HK on 22/4/25.
//

import SwiftUI

extension Color {
    
    static func color(hexString: String) -> Color {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        if Scanner(string: hexSanitized).scanHexInt64(&rgb) {
            let opacity = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            let red = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            let green = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            let blue = CGFloat((rgb & 0x000000FF)) / 255.0
            return Color(UIColor.init(red: CGFloat.init(red), green: CGFloat.init(green), blue: CGFloat.init(blue), alpha: CGFloat.init(opacity)))
        } else {
            return Color.clear
        }
    }
    
}
