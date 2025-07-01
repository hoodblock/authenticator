//
//  AuthenticatorScanView.swift
//  Authenticator
//
//  Created by SZ HK on 22/4/25.
//

import SwiftUI
import CodeScanner
import CoreImage.CIFilterBuiltins

struct AuthenticatorScanView: View {
    
    @Environment(\.presentationMode) var presentationMode

    var scanItemBlock: ((AuthenticatorItem) -> Void)?

    var body: some View {
        GeometryReader { geometry in
            ZStack () {
                Spacer()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .gradientBackColor([Color.color(hexString: "FFF2F2F6"), Color.color(hexString: "FFF2F2F6")], .topLeading)
                VStack (spacing: 0) {
                    Spacer()
                        .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
                    ZStack () {
                        // 标题
                        Text("Authenticator Scan")
                            .font(Font.auth_font(size: 16, .medium))
                            .foregroundColor(Color.color(hexString: "FF1A1A1A"))
                            .push(.center)
                        
                        // 返回按钮
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            HStack {
                                Image("point_left_black_icon")
                                    .resizeRatioFitSize(CGSize(width: safeWidth(geometry.size, 20), height: safeWidth(geometry.size, 20)))
                                    .padding(safeWidth(geometry.size, 10))
                            }
                        }
                        .restyle()
                        .push(.leading)
                    }
                    .padding([.leading, .trailing, .bottom], safeWidth(geometry.size, 10))
                    
                    // 内容
                    VStack (spacing: safeWidth(geometry.size, 40)) {
                        CodeScannerView(codeTypes: [.code128, .code39, .code39Mod43, .code93, .ean13, .ean8, .face, .pdf417, .qr], completion: onlineHandleScan)
                            .background(Color.color(hexString: "FFFFFFFF").opacity(0.2))
                        Button {
                            scanItemBlock!(AuthenticatorItem())
                        } label: {
                            HStack () {
                                Image("authenticator_code_icon")
                                    .resizeRatioFitSize(CGSize(width: safeWidth(geometry.size, 16), height: safeWidth(geometry.size, 16)))
                                Text("Enter code manually")
                                    .font(Font.auth_font(size: 14, .medium))
                                    .foregroundColor(Color.color(hexString: "FF3E55E5"))
                            }
                        }
                        .restyle()
                        .frame(width: geometry.size.width - safeWidth(geometry.size, 30) * 2, height: safeWidth(geometry.size, 50))
                        .rounded(safeWidth(geometry.size, 10), fill: Color.color(hexString: "FFFFFFFF"))
                        
                    }
                    .padding([.bottom], safeWidth(geometry.size, 40))
                }
            }
            .ignoresSafeArea(.all)
            .swipeToDismiss()
        }
        .statusBarHidden()
        .navigationBarBackButtonHidden()
    }
    
}

extension AuthenticatorScanView {

    /// 在线扫描结果
    func onlineHandleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let code):
            scanItemBlock!(AuthenticatorViewModel.shared.authenticatorItemFromSourceString(source: code.string))
        case .failure(let error):
            scanItemBlock!(AuthenticatorItem())
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct AuthenticatorScanView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticatorScanView()
    }
}
