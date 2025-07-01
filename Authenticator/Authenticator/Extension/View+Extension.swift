//
//  View+Extension.swift
//  Authenticator
//
//  Created by SZ HK on 22/4/25.
//

import SwiftUI


extension View {
    
    func safeWidth(_ size: CGSize, _ width: CGFloat) -> CGFloat {
        return width
    }
    
    func rounded(_ radiud: CGFloat, fill: some ShapeStyle) -> some View {
        background(RoundedRectangle(cornerRadius: radiud).fill(fill))
    }
    
    func gradientBackColor(_ colors: [Color], _ unitpoint: UnitPoint = .topLeading) -> some View {
        if unitpoint == .topLeading {
            return background(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
        } else if unitpoint == .leading {
            return background(LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing))
        } else if unitpoint == .top {
            return background(LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom))
        }
        return background(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
    }
    
    func gradientForeColor(_ colors: [Color], _ unitpoint: UnitPoint = .topLeading) -> some View {
        if unitpoint == .topLeading {
            return foregroundStyle(.linearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
        } else if unitpoint == .leading {
            return foregroundStyle(.linearGradient(colors: colors, startPoint: .leading, endPoint: .trailing))
        } else if unitpoint == .top {
            return foregroundStyle(.linearGradient(colors: colors, startPoint: .top, endPoint: .bottom))
        }
        return foregroundStyle(.linearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
    }
    
    func push(_ alignment: Alignment) -> some View {
        switch alignment {
        case .leading:
            return frame(maxWidth: .infinity, alignment: .leading)
        case .center:
            return frame(maxWidth: .infinity, alignment: .center)
        case .trailing:
            return frame(maxWidth: .infinity, alignment: .trailing)
        case .top:
            return frame(maxHeight: .infinity, alignment: .top)
        case .bottom:
            return frame(maxHeight: .infinity, alignment: .bottom)
        default:
            return frame(maxWidth: .infinity, alignment: alignment)
        }
    }
}


// 自定义修饰符，为view添加侧滑返回
struct SwipeToDismissModifier: ViewModifier {
    @Environment(\.dismiss) var dismiss
    
    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width > 100 {
                            dismiss()  // 触发自定义的侧滑返回
                        }
                    }
            )
    }
}

extension View {
    
    func swipeToDismiss() -> some View {
        self.modifier(SwipeToDismissModifier())
    }
}



// 自定义修饰符：添加 .contentShape(Rectangle())，确保整个区域都能响应点击
struct ClickableShapeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())  // 确保整个 HStack/VStack 都可以响应点击
    }
}

extension View {
    
    func clickableShape() -> some View {
        self.modifier(ClickableShapeModifier())
    }
}


extension Button {
    
    func restyle(_ backColor: Color) -> some View {
        background(backColor)
            .buttonStyle(.plain)
    }
    
    func restyle() -> some View {
        buttonStyle(.plain)
    }
}
