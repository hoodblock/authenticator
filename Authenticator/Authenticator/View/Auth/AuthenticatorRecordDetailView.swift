//
//  AuthenticatorRecordDetailView.swift
//  Authenticator
//
//  Created by SZ HK on 22/4/25.
//

import SwiftUI

struct AuthenticatorRecordDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var viewModel: AuthenticatorViewModel

    @ObservedObject var authenticatorItem: AuthenticatorItem = AuthenticatorItem()

    @State private var source: String = String()
    @State private var sharedSecret: String = String()
    @State private var nickName: String = String()
    @State private var modifiedTime: String = String()

    // 输入
    @FocusState private var shouldSourceFocused: Bool
    @FocusState private var shouldSharedSecretFocused: Bool
    @FocusState private var shouldNickNameFocused: Bool
    @FocusState private var shouldIntervalFocused: Bool

    // 进入编辑模式
    @State private var shouldEdittingMode: Bool = false
    @State private var shouldDone: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack () {
                Spacer()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .gradientBackColor([Color.color(hexString: "FFF2F2F6"), Color.color(hexString: "FFF2F2F6")], .topLeading)
                    .onTapGesture {
                        shouldSourceFocused = false
                        shouldSharedSecretFocused = false
                        shouldNickNameFocused = false
                        shouldIntervalFocused = false
                    }
                VStack (spacing: 0) {
                    Spacer()
                        .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
                    ZStack () {
                        // 标题
                        Text("Account Detail")
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
                        
                        Button {
                            viewModel.deleteAuthenticatorItem(authenticatorItem)
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image("password_delete_icon")
                                .resizeRatioFitSize(CGSize(width: safeWidth(geometry.size, 24), height: safeWidth(geometry.size, 24)))
                                .padding(safeWidth(geometry.size, 10))
                        }
                        .restyle()
                        .push(.trailing)
                    }
                    .padding([.leading, .trailing, .bottom], safeWidth(geometry.size, 10))
                    //
                    VStack (spacing: safeWidth(geometry.size, 15)) {
                        // source
                        VStack (spacing: safeWidth(geometry.size, 10)) {
                            Text("Issuer")
                                .font(Font.auth_font(size: 16, .medium))
                                .foregroundColor(Color.color(hexString: "FF131415"))
                                .push(.leading)
                            ZStack () {
                                RoundedRectangle(cornerRadius: safeWidth(geometry.size, 10))
                                    .frame(height: safeWidth(geometry.size, 48))
                                    .foregroundColor(Color.color(hexString: "FFFFFFFF"))
                                HStack () {
                                    TextField(authenticatorItem.source, text: $source)
                                        .focused($shouldSourceFocused)
                                        .keyboardType(.asciiCapable)
                                        .foregroundColor(Color.color(hexString: "#FF171C21"))
                                        .padding([.leading, .trailing], safeWidth(geometry.size, 20))
                                }
                            }
                        }
                        // nick
                        VStack (spacing: safeWidth(geometry.size, 10)) {
                            Text("Nick Name")
                                .font(Font.auth_font(size: 16, .medium))
                                .foregroundColor(Color.color(hexString: "FF131415"))
                                .push(.leading)
                            ZStack () {
                                RoundedRectangle(cornerRadius: safeWidth(geometry.size, 10))
                                    .frame(height: safeWidth(geometry.size, 48))
                                    .foregroundColor(Color.color(hexString: "FFFFFFFF"))
                                HStack () {
                                    TextField(authenticatorItem.nickName, text: $nickName)
                                        .focused($shouldNickNameFocused)
                                        .keyboardType(.asciiCapable)
                                        .foregroundColor(Color.color(hexString: "#FF171C21"))
                                        .padding([.leading, .trailing], safeWidth(geometry.size, 20))
                                }
                            }
                           
                        }
                        // Secret
                        VStack (spacing: safeWidth(geometry.size, 10)) {
                            Text("Secret")
                                .font(Font.auth_font(size: 16, .medium))
                                .foregroundColor(Color.color(hexString: "FF131415"))
                                .push(.leading)
                            ZStack () {
                                RoundedRectangle(cornerRadius: safeWidth(geometry.size, 10))
                                    .frame(height: safeWidth(geometry.size, 48))
                                    .foregroundColor(Color.color(hexString: "FFFFFFFF"))
                                HStack () {
                                    TextField(authenticatorItem.sharedSecret, text: $sharedSecret)
                                        .focused($shouldSharedSecretFocused)
                                        .keyboardType(.asciiCapable)
                                        .foregroundColor(Color.color(hexString: "#FF171C21"))
                                        .padding([.leading, .trailing], safeWidth(geometry.size, 20))
                                }
                            }
                           
                        }
                        // 时间
                        VStack (spacing: safeWidth(geometry.size, 10)) {
                            Text("Last modified time")
                                .font(Font.auth_font(size: 16, .medium))
                                .foregroundColor(Color.color(hexString: "FF131415"))
                                .push(.leading)
                            ZStack () {
                                RoundedRectangle(cornerRadius: safeWidth(geometry.size, 10))
                                    .frame(height: safeWidth(geometry.size, 48))
                                    .foregroundColor(Color.color(hexString: "FFFFFFFF"))
                                HStack () {
                                    TextField(DateFormatter.formatTimestamp(authenticatorItem.currentTime), text: $modifiedTime)
                                        .foregroundColor(Color.color(hexString: "#FF171C21"))
                                        .padding([.leading, .trailing], safeWidth(geometry.size, 20))
                                        .disabled(true)  // 禁用输入
                                }
                            }
                        }
                        // Options
                        VStack (spacing: safeWidth(geometry.size, 10)) {
                            Text("Advanced options")
                                .font(Font.auth_font(size: 16, .medium))
                                .foregroundColor(Color.color(hexString: "FF131415"))
                                .push(.leading)
                            VStack () {
                                HStack {
                                    Text("Algorithm")
                                        .font(Font.auth_font(size: 16, .regular))
                                        .foregroundColor(Color.color(hexString: "FF171C21"))
                                    Picker("", selection: $authenticatorItem.algorithm) {
                                        ForEach(Algorithm.allCases, id: \.self) { algorithm in
                                            Text(algorithm.rawValue)
                                        }
                                    }.pickerStyle(SegmentedPickerStyle())
                                }
                                .padding([.top, .bottom], safeWidth(geometry.size, 5))
                                HStack {
                                    Text("Digits")
                                        .font(Font.auth_font(size: 16, .regular))
                                        .foregroundColor(Color.color(hexString: "FF171C21"))
                                    Picker("", selection: $authenticatorItem.digits) {
                                        ForEach(Digit.allCases, id: \.self) { digit in
                                            Text(String(digit.rawValue)).tag(digit.rawValue)
                                        }
                                    }.pickerStyle(SegmentedPickerStyle())
                                }
                                .padding([.top, .bottom], safeWidth(geometry.size, 5))
                                HStack {
                                    Text("Interval")
                                        .font(Font.auth_font(size: 16, .regular))
                                        .foregroundColor(Color.color(hexString: "FF171C21"))
                                    Spacer()
                                    TextField("", value: $authenticatorItem.timeInterval, formatter: NumberFormatter())
                                        .focused($shouldIntervalFocused)
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.trailing)
                                }
                                .padding([.top, .bottom], safeWidth(geometry.size, 5))
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: safeWidth(geometry.size, 10))
                                    .foregroundColor(Color.color(hexString: "FFFFFFFF"))
                            )
                            HStack () {
                                Text("   If you are not familiar with these options, do not change them. Otherwise, the generated code will not work.")
                                    .foregroundColor(Color.color(hexString: "FFB1B1B4"))
                                    .push(.leading)
                                    .overlay {
                                        HStack () {
                                            VStack () {
                                                Text("*")
                                                    .foregroundColor(Color.color(hexString: "FFFF436D"))
                                                Spacer()
                                            }
                                            Spacer()
                                        }
                                    }
                                
                            }
                            .font(Font.auth_font(size: 16, .medium))
                        }
                        Spacer()
                        Button {
                            if shouldDone {
                                authenticatorItem.source = source
                                authenticatorItem.sharedSecret = sharedSecret
                                authenticatorItem.nickName = nickName
                                viewModel.changeAuthenticatorItem(authenticatorItem)
                                presentationMode.wrappedValue.dismiss()
                            }
                        } label: {
                            HStack () {
                                Text("Confirm")
                                    .font(Font.auth_font(size: 14, .medium))
                                    .foregroundColor(Color.color(hexString: "FFFFFFFF"))
                            }
                        }
                        .restyle()
                        .frame(width: geometry.size.width - safeWidth(geometry.size, 30) * 2, height: safeWidth(geometry.size, 50))
                        .rounded(safeWidth(geometry.size, 10), fill: shouldDone ? Color.color(hexString: "FF3E55E5") : Color.color(hexString: "FF3E55E5"))
                    }
                    .padding([.leading, .trailing], safeWidth(geometry.size, 20))
                    .padding([.bottom], safeWidth(geometry.size, 40))
                }
                .onChange(of: source) { newValue in
                    if !source.isEmpty && !sharedSecret.isEmpty && !nickName.isEmpty {
                        shouldDone = true
                    } else {
                        shouldDone = false
                    }
                }
                .onChange(of: sharedSecret) { newValue in
                    if !source.isEmpty && !sharedSecret.isEmpty && !nickName.isEmpty {
                        shouldDone = true
                    } else {
                        shouldDone = false
                    }
                }
                .onChange(of: nickName) { newValue in
                    if !source.isEmpty && !sharedSecret.isEmpty && !nickName.isEmpty {
                        shouldDone = true
                    } else {
                        shouldDone = false
                    }
                }
            }
            .ignoresSafeArea(.all)
            .swipeToDismiss()
            .onAppear {
                source = authenticatorItem.source
                sharedSecret = authenticatorItem.sharedSecret
                nickName = authenticatorItem.nickName
            }
        }
        .statusBarHidden()
        .navigationBarBackButtonHidden()
    }
    
}

extension DateFormatter {
    
    static let customFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy HH:mm:ss" // 例如: Mar 04, 2025 10:00:30
        return formatter
    }()

    static func formatTimestamp(_ timestamp: UInt64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return customFormatter.string(from: date)
    }
    
}


struct AuthenticatorRecordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticatorRecordDetailView(authenticatorItem: AuthenticatorItem())
            .environmentObject(AuthenticatorViewModel.shared)
    }
}
