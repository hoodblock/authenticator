//
//  AuthentocatorListView.swift
//  Authenticator
//
//  Created by SZ HK on 22/4/25.
//

import SwiftUI

enum AuthSelectedType: String {
    case authenticator = "Authenticator"
    case records = "Records"
}

struct AuthView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var authViewModel: AuthenticatorViewModel
            
    @EnvironmentObject var passwordViewModel: PasswordViewModel

    /// 选择项
    @State private var selectedType: AuthSelectedType = .authenticator


    /// records - 密码页面
    @State private var showAddRecordsView: Bool = false
    @State private var showPasswordDetailView: Bool = false
    @State private var passwordItem: PasswordItem = PasswordItem()
    
    /// authenticator - 身份验证页面
    @State private var showAuthenticatorScanView: Bool = false
    @State private var showAddAuthenticatorView: Bool = false
    @State private var showAuthenticatorDetailView: Bool = false
    @State private var authenticatorItem: AuthenticatorItem = AuthenticatorItem()

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
                        HStack (spacing: 0) {
                            // auctenticator
                            RoundedRectangle(cornerRadius: safeWidth(geometry.size, 16))
                                .frame(width: safeWidth(geometry.size, 140), height: safeWidth(geometry.size, 32))
                                .foregroundColor(selectedType == .authenticator ? Color.color(hexString: "FF1E3B62").opacity(0.1) : Color.clear)
                                .overlay {
                                    HStack () {
                                        if selectedType == .authenticator {
                                            Image("authenticator_icon")
                                                .resizeRatioFitSize(CGSize(width: safeWidth(geometry.size, 16), height: safeWidth(geometry.size, 16)))
                                        }
                                        Text("Authenticator")
                                            .font(Font.auth_font(size: 14, .medium))
                                            .foregroundColor(selectedType == .authenticator ? Color.color(hexString: "FF1E3B62") : Color.color(hexString: "FF1E3B62").opacity(0.5))
                                    }
                                }
                                .onTapGesture {
                                    selectedType = .authenticator
                                }
                            
                            // password
                            RoundedRectangle(cornerRadius: safeWidth(geometry.size, 16))
                                .frame(width: safeWidth(geometry.size, 110), height: safeWidth(geometry.size, 32))
                                .foregroundColor(selectedType == .records ? Color.color(hexString: "FF1E3B62").opacity(0.1) : Color.clear)
                                .overlay {
                                    HStack () {
                                        if selectedType == .records {
                                            Image("records_icon")
                                                .resizeRatioFitSize(CGSize(width: safeWidth(geometry.size, 16), height: safeWidth(geometry.size, 16)))
                                        }
                                        Text("Records")
                                            .font(Font.auth_font(size: 14, .medium))
                                            .foregroundColor(selectedType == .records ? Color.color(hexString: "FF1E3B62") : Color.color(hexString: "FF1E3B62").opacity(0.5))
                                    }
                                }
                                .onTapGesture {
                                    selectedType = .records
                                }
                        }
                        .push(.center)
                      
                        // 右边按钮
                        Button {
                            if selectedType == .records {
                                showAddRecordsView.toggle()
                            } else {
                                showAuthenticatorScanView.toggle()
                            }
                        } label: {
                            HStack {
                                Image("more_add_black_icon")
                                    .resizeRatioFitSize(CGSize(width: safeWidth(geometry.size, 20), height: safeWidth(geometry.size, 20)))
                                    .padding(safeWidth(geometry.size, 10))
                            }
                        }
                        .restyle()
                        .push(.trailing)
                    }
                    .padding([.leading, .trailing, .bottom], safeWidth(geometry.size, 10))
                    // 内容页面
                    if selectedType == .records {
                        recordsView(geometry: geometry)
                    } else {
                        authenticatorView(geometry: geometry)
                    }
                }
            }
            .ignoresSafeArea(.all)
            .swipeToDismiss()
            .navigationDestination(isPresented: $showAuthenticatorScanView) {
                AuthenticatorScanView { result in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        authenticatorItem = result
                        showAddAuthenticatorView.toggle()
                    }
                }
            }
            .navigationDestination(isPresented: $showAddAuthenticatorView) {
                AuthenticatorAddRecordView(authenticatorItem: authenticatorItem)
            }
            .navigationDestination(isPresented: $showAuthenticatorDetailView) {
                AuthenticatorRecordDetailView(authenticatorItem: authenticatorItem)
            }
            .navigationDestination(isPresented: $showAddRecordsView) {
                AddPasswordView()
            }
            .navigationDestination(isPresented: $showPasswordDetailView) {
                PasswordDetailView(passwordItem: passwordItem)
            }
            .onDisappear {
                authViewModel.stopAuthenticatorTasks()
            }
        }
        .statusBarHidden()
        .navigationBarBackButtonHidden()
    }
        
    // Authenticator
    func authenticatorView(geometry: GeometryProxy) -> some View {
        VStack () {
            if authViewModel.authenticatorSortList.count > 0 {
                List {
                    ForEach(authViewModel.authenticatorSortList, id: \.key) { letter, passwords in
                        Section(header:
                                Text(letter)
                                    .font(Font.auth_font(size: 14, .regular))
                                    .foregroundColor(Color.color(hexString: "FF131415"))
                        ) {
                            ForEach(passwords, id: \.uuid) { item in
                                VStack(spacing: safeWidth(geometry.size, 10)) {
                                    HStack () {
                                        Text(item.source)
                                            .font(Font.auth_font(size: 15, .medium))
                                            .foregroundColor(Color.color(hexString: "FF171C21"))
                                            .lineLimit(1)
                                        Text("·")
                                            .font(Font.auth_font(size: 15, .medium))
                                            .foregroundColor(Color.color(hexString: "FF171C21"))
                                            .lineLimit(1)
                                        Text(item.nickName)
                                            .font(Font.auth_font(size: 14, .regular))
                                            .foregroundColor(Color.color(hexString: "FFB1B1B4"))
                                            .lineLimit(1)
                                        Spacer()
                                        RoundedRectangle(cornerRadius: 15)
                                            .frame(width: safeWidth(geometry.size, 60), height: safeWidth(geometry.size, 30))
                                            .foregroundColor(Color.color(hexString: "FFF2F2F6"))
                                            .overlay {
                                                HStack() {
                                                    ZStack {
                                                        Circle()
                                                            .stroke(lineWidth: 4)
                                                            .opacity(0.3)
                                                            .foregroundColor(Color.color(hexString: "FF9B9B9E"))
                                                        Circle()
                                                            .trim(from: 0.0, to: CGFloat(min(max(0.00, item.progress), 1.0)))
                                                            .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                                                            .foregroundColor(item.progress > 0.8 ? Color.color(hexString: "FFFF436D") : Color.color(hexString: "FF3E55E5"))
                                                            .rotationEffect(Angle(degrees: 270))
                                                            .animation(.linear)
                                                    }
                                                    .frame(width: safeWidth(geometry.size, 15), height: safeWidth(geometry.size, 15))
                                                    // 这个处理界面负数情况
                                                    Text(String((item.timeInterval - Int(UInt64(Date().timeIntervalSince1970) - item.requestCodeTime)) < 0 ? 0 : (item.timeInterval - Int(UInt64(Date().timeIntervalSince1970) - item.requestCodeTime))))
                                                        .font(Font.auth_font(size: 14, .medium))
                                                        .foregroundColor(Color.color(hexString: "FF000000"))
                                                }
                                            }
                                    }
                                    HStack () {
                                        Text(item.verificationCode.count > 5 ? (item.verificationCode.prefix(3) + "  " + item.verificationCode.suffix(3)) : item.verificationCode)
                                            .font(Font.auth_font(size: 28, .bold))
                                            .foregroundColor(Color.color(hexString: "FF3E55E5"))
                                            .padding([.trailing], safeWidth(geometry.size, 25))
                                        Button {
                                            UIPasteboard.general.string = item.verificationCode
                                        } label: {
                                            HStack () {
                                                Image("password_copy_icon")
                                                    .resizeRatioFitSize(CGSize(width: safeWidth(geometry.size, 18), height: safeWidth(geometry.size, 18)))
                                            }
                                        }
                                        .restyle()
                                        Spacer()
                                    }
                                }
                                .padding()
                                .rounded(safeWidth(geometry.size, 12), fill: Color.color(hexString: "FFFFFFFF"))
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .onTapGesture {
                                    authenticatorItem = item
                                    showAuthenticatorDetailView.toggle()
                                }
                                .tag(item.uuid)
                                .onAppear {
                                    item.startRequestCode()
                                }
                            }
                        }
                    }
                }
                .background(Color.clear)
                .listStyle(PlainListStyle())
            } else {
                VStack (spacing: safeWidth(geometry.size, 40)) {
                    Spacer()
                    VStack (spacing: safeWidth(geometry.size, 15)) {
                        Image("authenticator_background_icon")
                            .resizeRatioFitSize(CGSize(width: safeWidth(geometry.size, 120), height: safeWidth(geometry.size, 120)))
                        Text("Accept verified IDs for better identity control.")
                            .font(Font.auth_font(size: 14, .regular))
                            .foregroundColor(Color.color(hexString: "FF1A1A1A"))
                        Text("Some websites and organizations now offer 2FA authentication, making account setup easier and more secure.")
                            .font(Font.auth_font(size: 14, .regular))
                            .foregroundColor(Color.color(hexString: "FF8A8A8E"))
                            .multilineTextAlignment(.center)
                    }
                    VStack (spacing: safeWidth(geometry.size, 15)) {
                        Button {
                            showAuthenticatorScanView.toggle()
                        } label: {
                            HStack () {
                                Image("authenticator_scan_icon")
                                    .resizeRatioFitSize(CGSize(width: safeWidth(geometry.size, 16), height: safeWidth(geometry.size, 16)))
                                Text("Scan QR-code")
                                    .font(Font.auth_font(size: 14, .medium))
                                    .foregroundColor(Color.color(hexString: "FFFFFFFF"))
                            }
                        }
                        .restyle()
                        .frame(width: geometry.size.width - safeWidth(geometry.size, 30) * 2, height: safeWidth(geometry.size, 50))
                        .rounded(safeWidth(geometry.size, 10), fill: Color.color(hexString: "FF3E55E5"))
                        
                        Button {
                            showAddAuthenticatorView.toggle()
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
                    Spacer()
                    Spacer()
                }
                .padding([.leading, .trailing], safeWidth(geometry.size, 20))
            }
        }
    }
    
    // passwordRecords
    func recordsView(geometry: GeometryProxy) -> some View {
        VStack () {
            if passwordViewModel.passwordList.count > 0 {
                List {
                    ForEach(passwordViewModel.alphabeticallyGroupedPasswords(), id: \.key) { letter, passwords in
                        Section(header:
                                Text(letter)
                                    .font(Font.auth_font(size: 14, .regular))
                                    .foregroundColor(Color.color(hexString: "FF131415"))
                        ) {
                            ForEach(passwords, id: \.uuid) { item in
                                VStack (spacing: safeWidth(geometry.size, 10)) {
                                    HStack () {
                                        Text(item.source)
                                            .font(Font.auth_font(size: 16, .bold))
                                            .foregroundColor(Color.color(hexString: "FF171C21"))
                                            .lineLimit(1)
                                        Spacer()
                                    }
                                    HStack() {
                                        Text(item.account)
                                            .font(Font.auth_font(size: 14, .regular))
                                            .foregroundColor(Color.color(hexString: "FFB1B1B4"))
                                            .lineLimit(1)
                                        Spacer()
                                    }
                                }
                                .padding()
                                .rounded(safeWidth(geometry.size, 12), fill: Color.color(hexString: "FFFFFFFF"))
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .onTapGesture {
                                    passwordItem = item
                                    showPasswordDetailView.toggle()
                                }
                                .tag(item.uuid)
                               
                            }
                        }
                    }
                }
                .background(Color.clear)
                .listStyle(PlainListStyle())
            } else {
                VStack (spacing: safeWidth(geometry.size, 40)) {
                    Spacer()
                    VStack (spacing: safeWidth(geometry.size, 15)) {
                        Image("no_history_data_icon")
                            .resizeRatioFitSize(CGSize(width: safeWidth(geometry.size, 150), height: safeWidth(geometry.size, 150)))
                        Text("Permanently save your account and password and update them in time to make access safe and convenient.")
                            .font(Font.auth_font(size: 14, .regular))
                            .foregroundColor(Color.color(hexString: "FF8A8A8E"))
                            .multilineTextAlignment(.center)
                    }
                  
                    Button {
                        showAddRecordsView.toggle()
                    } label: {
                        HStack () {
                            Image("password_add_icon")
                                .resizeRatioFitSize(CGSize(width: safeWidth(geometry.size, 16), height: safeWidth(geometry.size, 16)))
                            Text("Account and Password")
                                .font(Font.auth_font(size: 14, .medium))
                                .foregroundColor(Color.color(hexString: "FFFFFFFF"))
                        }
                    }
                    .restyle()
                    .frame(width: geometry.size.width - safeWidth(geometry.size, 30) * 2, height: safeWidth(geometry.size, 50))
                    .rounded(safeWidth(geometry.size, 10), fill: Color.color(hexString: "FF3E55E5"))
                    
                    Spacer()
                    Spacer()
                }
                .padding([.leading, .trailing], safeWidth(geometry.size, 20))
            }
        }
    }
}


struct AuthentocatorListView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
            .environmentObject(AuthenticatorViewModel.shared)
            .environmentObject(PasswordViewModel.shared)
    }
}
