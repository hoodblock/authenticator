//
//  Image+Extension.swift
//  Authenticator
//
//  Created by SZ HK on 22/4/25.
//

import SwiftUI


extension Image {
    
    func resizeRatioFit() -> some View {
        resizable()
        .aspectRatio(contentMode: .fit)
    }
    
    func resizeRatioFill() -> some View {
        resizable()
        .aspectRatio(contentMode: .fill)
    }
    
    func resizeRatioFitSize(_ size: CGSize) -> some View {
        resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: size.width, height: size.height)
    }
    
    func resizeRatioFillSize(_ size: CGSize) -> some View {
        resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: size.width, height: size.height)
    }

}
