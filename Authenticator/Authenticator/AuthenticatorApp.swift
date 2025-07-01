//
//  AuthenticatorApp.swift
//  Authenticator
//
//  Created by SZ HK on 22/4/25.
//

import SwiftUI
import AppTrackingTransparency


class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
}


@main
struct AuthenticatorApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase

    // 弹窗授权
    @State private var isATTrackingCompleted: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthenticatorViewModel.shared)
                .environmentObject(PasswordViewModel.shared)
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active: appActiveStatus()
                print("【 AuthenticatorApp 】____【 active 】")
            case .inactive: appInactiveStatus()
                print("【 AuthenticatorApp 】____【 inactive 】")
            case .background: appBackgroundStatus()
                print("【 AuthenticatorApp 】____【 background 】")
            }
        }
    }
    
    func appInactiveStatus() {
    }
    
    func appBackgroundStatus() {
      
    }
    
    func appActiveStatus() {
        ///授权
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            requestIDFAPermission()
        }
    }
    
    func requestIDFAPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
            }
        }
    }
}
