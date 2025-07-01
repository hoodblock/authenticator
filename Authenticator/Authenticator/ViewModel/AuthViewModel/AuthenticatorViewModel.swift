//
//  AuthenticatorViewModel.swift
//  Authenticator
//
//  Created by SZ HK on 22/4/25.
//

import Foundation
import Security
import SwiftOTP

/// 用来存储账号基础信息
let KEYCHINA_AUTHENTICATOR_ACCOUNT_KEY = "KEYCHINA_AUTHENTICATOR_ACCOUNT_KEY"
/// 用来存储时间信息，因为会预防定时器销毁的情况
let USERDEFAULT_AUTHENTICATOR_ACCOUNT_KEY = "USERDEFAULT_AUTHENTICATOR_ACCOUNT_KEY"

class AuthenticatorViewModel: NSObject, ObservableObject {
    
    static let shared = AuthenticatorViewModel()

    @Published private var authenticatorList: [AuthenticatorItem] = []

    /// 这里要观察字母排序后的列表
    @Published var authenticatorSortList: [(key: String, value: [AuthenticatorItem])] = []

    private override init() {
        super.init()
        loadAuthenticatorItems()
        alphabeticallyGroupedAuthenticators()
    }
}

// MARK: - authenticator
extension AuthenticatorViewModel {
    
    /// 存储到Keychain
    private func saveAuthenticatorItems(to keyChina: Bool) -> Bool {
        let encoder = JSONEncoder()
        if keyChina {
            do {
                let encodedItems = try encoder.encode(authenticatorList)
                let query: [CFString: Any] = [
                    kSecClass: kSecClassGenericPassword,
                    kSecAttrAccount: KEYCHINA_AUTHENTICATOR_ACCOUNT_KEY,
                    kSecValueData: encodedItems
                ]
                SecItemDelete(query as CFDictionary)
                let status = SecItemAdd(query as CFDictionary, nil)
                return status == errSecSuccess
            } catch {
                print("Error encoding password items: \(error)")
                return false
            }
        } else {
            do {
                let encodedItems = try encoder.encode(authenticatorList)
                UserDefaults.standard.set(encodedItems, forKey: USERDEFAULT_AUTHENTICATOR_ACCOUNT_KEY)
                UserDefaults.standard.synchronize()
                return true
            } catch {
                print("Error encoding password items: \(error)")
                return false
            }
        }
    }
    
    /// 获取总列表
    private func loadAuthenticatorItems() {
        // 获取keychina
        var keyChinaAuthenticatorList: [AuthenticatorItem] = []
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: KEYCHINA_AUTHENTICATOR_ACCOUNT_KEY,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else {
            keyChinaAuthenticatorList = []
            return
        }
        let decoder = JSONDecoder()
        do {
            let decodedItems = try decoder.decode([AuthenticatorItem].self, from: data)
            keyChinaAuthenticatorList = decodedItems
        } catch {
            print("keychina Error decoding password items: \(error)")
            keyChinaAuthenticatorList = []
        }
        
        // 获取userdefault
        var userdefaultAuthenticatorList: [AuthenticatorItem] = []
        do {
            let decodedItems = try decoder.decode([AuthenticatorItem].self, from: UserDefaults.standard.data(forKey: USERDEFAULT_AUTHENTICATOR_ACCOUNT_KEY) ?? Data())
            userdefaultAuthenticatorList = decodedItems
        } catch {
            print("userdefault Error decoding password items: \(error)")
            userdefaultAuthenticatorList = []
        }
        // 不相等时，强制复制keychina的数据到user default
        if userdefaultAuthenticatorList.count != keyChinaAuthenticatorList.count {
            UserDefaults.standard.set(data, forKey: USERDEFAULT_AUTHENTICATOR_ACCOUNT_KEY)
            UserDefaults.standard.synchronize()
            authenticatorList = keyChinaAuthenticatorList
        } else {
            authenticatorList = userdefaultAuthenticatorList
        }
    }
    
    /// 添加AuthenticatorItem
    public func addAuthenticatorItem(_ item: AuthenticatorItem) {
        item.currentTime = UInt64(Date().timeIntervalSince1970)
        // 当账号来源和用户名相同时，认为是同一个账户，直接覆盖之前的数据
        if authenticatorList.contains(where: { ($0.nickName == item.nickName) && ($0.source == item.source) }) {
            if let index = authenticatorList.firstIndex(where: { ($0.nickName == item.nickName) && ($0.source == item.source) }) {
                authenticatorList[index] = item
            }
        } else {
            authenticatorList.append(item)
        }
        _ = saveAuthenticatorItems(to: true)
        _ = saveAuthenticatorItems(to: false)
        alphabeticallyGroupedAuthenticators()
    }
    
    /// 删除某个AuthenticatorItem
    public func deleteAuthenticatorItem(_ item: AuthenticatorItem) {
        if let index = authenticatorList.firstIndex(where: { $0.uuid == item.uuid }) {
            authenticatorList.remove(at: index)
        }
        _ = saveAuthenticatorItems(to: true)
        _ = saveAuthenticatorItems(to: false)
        alphabeticallyGroupedAuthenticators()
    }
    
    /// 修改某个AuthenticatorItem
    public func changeAuthenticatorItem(_ item: AuthenticatorItem) {
        item.currentTime = UInt64(Date().timeIntervalSince1970)
        if let index = authenticatorList.firstIndex(where: { $0.uuid == item.uuid }) {
            authenticatorList[index] = item
        }
        _ = saveAuthenticatorItems(to: true)
        _ = saveAuthenticatorItems(to: false)
        alphabeticallyGroupedAuthenticators()
    }
    
    public func changeAuthenticatorItemFromUserdefault(_ item: AuthenticatorItem) {
        if let index = authenticatorList.firstIndex(where: { $0.uuid == item.uuid }) {
            authenticatorList[index] = item
        }
        _ = saveAuthenticatorItems(to: false)
        alphabeticallyGroupedAuthenticators()
    }
    
    /// 解析TOTP(time-one-time-password)的原始数据
    /// let otpauthURL = "otpauth://totp/GitHub:hoodblock?secret=6SUPCXAFOJPTRGDY&issuer=GitHub"
    public func authenticatorItemFromSourceString(source: String) -> AuthenticatorItem {
        let authenticatorItem: AuthenticatorItem = AuthenticatorItem()
        if let url = URL(string: source) {
            authenticatorItem.linkUrlString = source
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            if let path = components?.path {
                authenticatorItem.nickName = String(path.split(separator: ":").last ?? "")
            }
            if let queryItems = components?.queryItems {
                for item in queryItems {
                    if item.name == "secret" {
                        authenticatorItem.sharedSecret = item.value ?? "Unknown"
                    } else if item.name == "issuer" {
                        authenticatorItem.source = item.value ?? "Unknown"
                    }
                }
            }
        }
        return authenticatorItem
    }
    
    /// 停止身份验证定时任务
    public func stopAuthenticatorTasks() {
        for item in authenticatorSortList {
            for authenticatorItem in item.value {
                authenticatorItem.stopRequestCode()
            }
        }
        for authenticatorItem in authenticatorList {
            authenticatorItem.stopRequestCode()
        }
    }
}

extension AuthenticatorViewModel {
    
    // 按首字母分组并按字母排序
    private func alphabeticallyGroupedAuthenticators() {
        let grouped = Dictionary(grouping: authenticatorList, by: { String($0.source.prefix(1)).uppercased() })
        let sortedGrouped = grouped.sorted { $0.key < $1.key }
        authenticatorSortList =  sortedGrouped
    

    }
    
}
