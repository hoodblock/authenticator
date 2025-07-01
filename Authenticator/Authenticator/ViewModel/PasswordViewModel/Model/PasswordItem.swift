//
//  PasswordItem.swift
//  Authenticator
//
//  Created by nan on 2025/6/28.
//

import Foundation
import SwiftOTP

class PasswordItem: Identifiable, ObservableObject, Codable {
    /// 唯一ID
    @Published var uuid: UUID = UUID()
    /// 当前时间戳（作为添加时间）
    @Published var currentTime: UInt64 = 0
    ///  来源
    @Published var source: String = String()
    ///  账户（邮箱或者手机号）
    @Published var account: String = String()
    ///  密码
    @Published var password: String = String()
    ///  账户昵称
    @Published var nickName: String = String()
    ///  链接地址
    @Published var linkUrlString: String = String()
    ///  备注
    @Published var notes: String = String()
  
    init() {
        
    }
    // MARK: - Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uuid = try container.decodeIfPresent(UUID.self, forKey: .uuid) ?? UUID()
        self.currentTime = try container.decodeIfPresent(UInt64.self, forKey: .currentTime) ?? 0
        self.source = try container.decodeIfPresent(String.self, forKey: .source) ?? ""
        self.account = try container.decodeIfPresent(String.self, forKey: .account) ?? ""
        self.password = try container.decodeIfPresent(String.self, forKey: .password) ?? ""
        self.nickName = try container.decodeIfPresent(String.self, forKey: .nickName) ?? ""
        self.linkUrlString = try container.decodeIfPresent(String.self, forKey: .linkUrlString) ?? ""
        self.notes = try container.decodeIfPresent(String.self, forKey: .notes) ?? ""
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(currentTime, forKey: .currentTime)
        try container.encode(source, forKey: .source)
        try container.encode(account, forKey: .account)
        try container.encode(password, forKey: .password)
        try container.encode(nickName, forKey: .nickName)
        try container.encode(linkUrlString, forKey: .linkUrlString)
        try container.encode(notes, forKey: .notes)
    }
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case currentTime
        case source
        case account
        case password
        case nickName
        case linkUrlString
        case notes
    }
}
