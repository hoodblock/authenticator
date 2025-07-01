//
//  Font+Extension.swift
//  Authenticator
//
//  Created by SZ HK on 22/4/25.
//

import SwiftUI

extension Font {
    
    static func B_Width(_ size: CGFloat) -> CGFloat {
        return size
    }
}


extension Font {
   
    static func auth_font(size: CGFloat, _ weight: Font.Weight = .regular) -> Font { Font.custom(fontName(weight), size: B_Width(size)) }

    static func fontName(_ weight: Font.Weight) -> String {
        switch weight {
        case .regular:
            return "SFPro-Regular"
        case .medium:
            return "SFPro-Medium"
        case .bold:
            return "SFPro-Bold"
        default:
            return "SFPro-Regular"
        }
    }
}
