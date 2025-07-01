//
//  PasswordViewModel.swift
//  Authenticator
//
//  Created by nan on 2025/6/28.
//

import Foundation
import Security

let KEYCHINA_PASSWORD_ACCOUNT_KEY = "KEYCHINA_PASSWORK_ACCOUNT_KEY"

class PasswordViewModel: NSObject, ObservableObject {
    
    static let shared = PasswordViewModel()

    @Published var passwordList: [PasswordItem] = []

    private override init() {
        super.init()
        loadPasswordItems()
    }
}

// MARK: - Password
extension PasswordViewModel {
    
    /// 存储到Keychain
    private func savePasswordItems() -> Bool {
        // 将 PasswordItem 列表编码为 Data
        let encoder = JSONEncoder()
        do {
            let encodedItems = try encoder.encode(passwordList)
            let query: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: KEYCHINA_PASSWORD_ACCOUNT_KEY,
                kSecValueData: encodedItems
            ]
            // 删除现有的值
            SecItemDelete(query as CFDictionary)
            // 添加新的值
            let status = SecItemAdd(query as CFDictionary, nil)
            return status == errSecSuccess
        } catch {
            print("Error encoding password items: \(error)")
            return false
        }
    }
    
    /// 获取总列表
    private func loadPasswordItems() {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: KEYCHINA_PASSWORD_ACCOUNT_KEY,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess, let data = result as? Data else {
            passwordList = []
            return
        }
        let decoder = JSONDecoder()
        do {
            let decodedItems = try decoder.decode([PasswordItem].self, from: data)
            passwordList = decodedItems
        } catch {
            print("Error decoding password items: \(error)")
            passwordList = []
        }
    }
    
    // 添加PasswordItem
    public func addPasswordItem(_ item: PasswordItem) {
        item.currentTime = UInt64(Date().timeIntervalSince1970)
        passwordList.append(item)
        _ = savePasswordItems()
    }
    
    // 删除某个password
    public func deletePasswordItem(_ item: PasswordItem) {
        if let index = passwordList.firstIndex(where: { $0.uuid == item.uuid }) {
            passwordList.remove(at: index)
        }
        _ = savePasswordItems()
    }
    
    // 修改某个password
    public func changePasswordItem(_ item: PasswordItem) {
        item.currentTime = UInt64(Date().timeIntervalSince1970)
        if let index = passwordList.firstIndex(where: { $0.uuid == item.uuid }) {
            passwordList[index] = item
        }
        _ = savePasswordItems()
    }
}

extension PasswordViewModel {
    
    // 按首字母分组并按字母排序
    public func alphabeticallyGroupedPasswords() -> [(key: String, value: [PasswordItem])] {
        let grouped = Dictionary(grouping: passwordList, by: { String($0.source.prefix(1)).uppercased() })
        let sortedGrouped = grouped.sorted { $0.key < $1.key }
        return sortedGrouped
    }
    
}
