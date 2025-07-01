//
//  PasswordDetailView.swift
//  Authenticator
//
//  Created by nan on 2025/6/28.
//

import SwiftUI

struct PasswordDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var viewModel: PasswordViewModel

    @State var passwordItem: PasswordItem = PasswordItem()
    
    @State private var source: String = String()
    @State private var account: String = String()
    @State private var password: String = String()
    @State private var nickName: String = String()
    @State private var websiteURL: String = String()
    @State private var modifiedTime: String = String()

    // 输入
    @FocusState private var shouldSourceFocused: Bool
    @FocusState private var shouldAccountFocused: Bool
    @FocusState private var shouldPasswordFocused: Bool
    @FocusState private var shouldNickNameFocused: Bool
    @FocusState private var shouldWebsiteUrlFocused: Bool

    // 进入编辑模式
    @State private var shouldEdittingMode: Bool = false
    @State private var shouldDone: Bool = false

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
                        Text("Detail")
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
                            viewModel.deletePasswordItem(passwordItem)
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
                            Text("Source")
                                .font(Font.auth_font(size: 16, .medium))
                                .foregroundColor(Color.color(hexString: "FF131415"))
                                .push(.leading)
                            ZStack () {
                                RoundedRectangle(cornerRadius: safeWidth(geometry.size, 10))
                                    .frame(height: safeWidth(geometry.size, 48))
                                    .foregroundColor(Color.color(hexString: "FFFFFFFF"))
                                HStack () {
                                    TextField(passwordItem.source, text: $source)
                                        .focused($shouldSourceFocused)
                                        .keyboardType(.asciiCapable)
                                        .foregroundColor(Color.color(hexString: "#FF171C21"))
                                        .padding([.leading, .trailing], safeWidth(geometry.size, 20))
                                }
                            }
                        }
                        // account
                        VStack (spacing: safeWidth(geometry.size, 10)) {
                            Text("Account")
                                .font(Font.auth_font(size: 16, .medium))
                                .foregroundColor(Color.color(hexString: "FF131415"))
                                .push(.leading)
                            ZStack () {
                                RoundedRectangle(cornerRadius: safeWidth(geometry.size, 10))
                                    .frame(height: safeWidth(geometry.size, 48))
                                    .foregroundColor(Color.color(hexString: "FFFFFFFF"))
                                HStack () {
                                    TextField(passwordItem.account, text: $account)
                                        .focused($shouldAccountFocused)
                                        .keyboardType(.asciiCapable)
                                        .foregroundColor(Color.color(hexString: "#FF171C21"))
                                        .padding([.leading, .trailing], safeWidth(geometry.size, 20))
                                }
                            }
                        }
                        // password
                        VStack (spacing: safeWidth(geometry.size, 10)) {
                            Text("Password")
                                .font(Font.auth_font(size: 16, .medium))
                                .foregroundColor(Color.color(hexString: "FF131415"))
                                .push(.leading)
                            ZStack () {
                                RoundedRectangle(cornerRadius: safeWidth(geometry.size, 10))
                                    .frame(height: safeWidth(geometry.size, 48))
                                    .foregroundColor(Color.color(hexString: "FFFFFFFF"))
                                HStack () {
                                    TextField(passwordItem.password, text: $password)
                                        .focused($shouldPasswordFocused)
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
                                .foregroundColor(Color.color(hexString: "FF1A1A1A"))
                                .push(.leading)
                            ZStack () {
                                RoundedRectangle(cornerRadius: safeWidth(geometry.size, 10))
                                    .frame(height: safeWidth(geometry.size, 48))
                                    .foregroundColor(Color.color(hexString: "FFFFFFFF"))
                                HStack () {
                                    TextField(passwordItem.nickName, text: $nickName)
                                        .focused($shouldNickNameFocused)
                                        .keyboardType(.asciiCapable)
                                        .foregroundColor(Color.color(hexString: "#FF171C21"))
                                        .padding([.leading, .trailing], safeWidth(geometry.size, 20))
                                }
                            }
                           
                        }
                        // url
                        VStack (spacing: safeWidth(geometry.size, 10)) {
                            Text("Website URL")
                                .font(Font.auth_font(size: 16, .medium))
                                .foregroundColor(Color.color(hexString: "FF1A1A1A"))
                                .push(.leading)
                            ZStack () {
                                RoundedRectangle(cornerRadius: safeWidth(geometry.size, 10))
                                    .frame(height: safeWidth(geometry.size, 48))
                                    .foregroundColor(Color.color(hexString: "FFFFFFFF"))
                                HStack () {
                                    TextField(passwordItem.linkUrlString, text: $websiteURL)
                                        .focused($shouldWebsiteUrlFocused)
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
                                .foregroundColor(Color.color(hexString: "FF1A1A1A"))
                                .push(.leading)
                            ZStack () {
                                RoundedRectangle(cornerRadius: safeWidth(geometry.size, 10))
                                    .frame(height: safeWidth(geometry.size, 48))
                                    .foregroundColor(Color.color(hexString: "FFFFFFFF"))
                                HStack () {
                                    TextField(DateFormatter.formatTimestamp(passwordItem.currentTime), text: $modifiedTime)
                                        .foregroundColor(Color.color(hexString: "#FF171C21"))
                                        .padding([.leading, .trailing], safeWidth(geometry.size, 20))
                                        .disabled(true)  // 禁用输入
                                }
                            }
                        }
                        Spacer()
                        
                        Button {
                            if shouldDone {
                                passwordItem.source = source
                                passwordItem.account = account
                                passwordItem.password = password
                                passwordItem.nickName = nickName
                                passwordItem.linkUrlString = websiteURL
                                viewModel.changePasswordItem(passwordItem)
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
                .onTapGesture {
                    shouldSourceFocused = false
                    shouldAccountFocused = false
                    shouldPasswordFocused = false
                    shouldNickNameFocused = false
                    shouldWebsiteUrlFocused = false
                }
                .onChange(of: source) { newValue in
                    if !source.isEmpty && !account.isEmpty && !password.isEmpty {
                        shouldDone = true
                    } else {
                        shouldDone = false
                    }
                }
                .onChange(of: account) { newValue in
                    if !source.isEmpty && !account.isEmpty && !password.isEmpty {
                        shouldDone = true
                    } else {
                        shouldDone = false
                    }
                }
                .onChange(of: password) { newValue in
                    if !source.isEmpty && !account.isEmpty && !password.isEmpty {
                        shouldDone = true
                    } else {
                        shouldDone = false
                    }
                }
            }
            .ignoresSafeArea(.all)
            .swipeToDismiss()
            .onAppear {
                source = passwordItem.source
                account = passwordItem.account
                password = passwordItem.password
                nickName = passwordItem.nickName
                websiteURL = passwordItem.linkUrlString
                modifiedTime = DateFormatter.formatTimestamp(passwordItem.currentTime)
            }
        }
        .statusBarHidden()
        .navigationBarBackButtonHidden()
    }
    
}



struct PasswordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordDetailView()
            .environmentObject(PasswordViewModel.shared)
    }
}
