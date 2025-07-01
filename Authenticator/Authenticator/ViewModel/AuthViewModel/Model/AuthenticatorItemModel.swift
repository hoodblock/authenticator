//
//  AuthenticatorItemModel.swift
//  Authenticator
//
//  Created by SZ HK on 22/4/25.
//

import Foundation
import SwiftOTP

enum Algorithm: String, CaseIterable, Codable {
    case sha1 = "SHA1"
    case sha256 = "SHA256"
    case sha512 = "SHA512"
}

enum Digit: Int, CaseIterable, Codable {
    case six = 6
    case eight = 8
}

class AuthenticatorItem: Identifiable, ObservableObject, Codable {
    /// 唯一ID
    @Published var uuid: UUID = UUID()
    /// 当前时间戳（作为添加时间）
    @Published var currentTime: UInt64 = 0
    ///  来源
    @Published var source: String = String()
    ///  链接地址
    @Published var linkUrlString: String = String()
    ///  账户昵称
    @Published var nickName: String = String()
    ///  共享密钥
    @Published var sharedSecret: String = String()
    ///  验证码
    @Published var verificationCode: String = "000000"
    ///  config - 验证码有效时间
    @Published var timeInterval: Int = 30
    ///  config - 验证位数
    @Published var digits: Digit = Digit.six
    ///  config - 加密方式
    @Published var algorithm: Algorithm = Algorithm.sha1
    ///  config - 有效验证码的请求时间（保存到本地，这会导致界面指定时间更新一次数据，本地数据也会同步更新）
    @Published var requestCodeTime: UInt64 = 0
    ///  config - 验证码的进度
    @Published var progress: CGFloat = 0.00
    ///  config - 是否可以请求临时验证码
    @Published var shouldRequest: Bool = true

    /// 定时器，每秒执行
    private var timer: Timer?

    init() {
    }
    
    // MARK: - Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uuid = try container.decodeIfPresent(UUID.self, forKey: .uuid) ?? UUID()
        self.currentTime = try container.decodeIfPresent(UInt64.self, forKey: .currentTime) ?? 0
        self.source = try container.decodeIfPresent(String.self, forKey: .source) ?? ""
        self.linkUrlString = try container.decodeIfPresent(String.self, forKey: .linkUrlString) ?? ""
        self.nickName = try container.decodeIfPresent(String.self, forKey: .nickName) ?? ""
        self.sharedSecret = try container.decodeIfPresent(String.self, forKey: .sharedSecret) ?? ""
        self.verificationCode = try container.decodeIfPresent(String.self, forKey: .verificationCode) ?? "000000"
        self.timeInterval = try container.decodeIfPresent(Int.self, forKey: .timeInterval) ?? 30
        self.digits = try container.decodeIfPresent(Digit.self, forKey: .digits) ?? .six
        self.algorithm = try container.decodeIfPresent(Algorithm.self, forKey: .algorithm) ?? .sha1
        self.algorithm = try container.decodeIfPresent(Algorithm.self, forKey: .algorithm) ?? .sha1
        self.algorithm = try container.decodeIfPresent(Algorithm.self, forKey: .algorithm) ?? .sha1
        self.requestCodeTime = try container.decodeIfPresent(UInt64.self, forKey: .requestCodeTime) ?? 0
        self.progress = try container.decodeIfPresent(CGFloat.self, forKey: .progress) ?? 0.00
        self.shouldRequest = try container.decodeIfPresent(Bool.self, forKey: .shouldRequest) ?? true
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(currentTime, forKey: .currentTime)
        try container.encode(source, forKey: .source)
        try container.encode(linkUrlString, forKey: .linkUrlString)
        try container.encode(nickName, forKey: .nickName)
        try container.encode(sharedSecret, forKey: .sharedSecret)
        try container.encode(verificationCode, forKey: .verificationCode)
        try container.encode(timeInterval, forKey: .timeInterval)
        try container.encode(digits, forKey: .digits)
        try container.encode(algorithm, forKey: .algorithm)
        try container.encode(requestCodeTime, forKey: .requestCodeTime)
        try container.encode(progress, forKey: .progress)
        try container.encode(shouldRequest, forKey: .shouldRequest)
    }
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case currentTime
        case source
        case linkUrlString
        case nickName
        case sharedSecret
        case verificationCode
        case timeInterval
        case digits
        case algorithm
        case requestCodeTime
        case progress
        case shouldRequest
    }
    
    /// 根据配置获取验证码
    func generate() {
        // 当前时间已经超过请求时间和时间窗口嘛，那么会重新请求验证码
        if (UInt64(Date().timeIntervalSince1970) - requestCodeTime >= timeInterval) && shouldRequest {
            shouldRequest = false
            if let data = base32DecodeToData(sharedSecret) {
                var totpAlgorithm: OTPAlgorithm = .sha1
                if algorithm == .sha1 {
                    totpAlgorithm = .sha1
                } else if algorithm == .sha256 {
                    totpAlgorithm = .sha256
                } else {
                    totpAlgorithm = .sha512
                }
                if let totp = TOTP(secret: data, digits: digits.rawValue, timeInterval: timeInterval, algorithm: totpAlgorithm) {
                    if let code: String = totp.generate(time: Date()) {
                        verificationCode = code
                        // 请求到验证码，重新复制请求时间
                        requestCodeTime = UInt64(Date().timeIntervalSince1970)
                        // 重新保存数据
                        shouldRequest = true
                    } else {
                        shouldRequest = true
                    }
                } else {
                    shouldRequest = true
                }
            } else {
                shouldRequest = true
            }
        }
    }
    
    /// 启动数据验证
    func startRequestCode() {
        if sharedSecret.count == 0 {
            return
        }
        if self.timer != nil {
            stopRequestCode()
        }
        self.shouldRequest = true
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            DispatchQueue.main.async {
                if UInt64(Date().timeIntervalSince1970) - self.requestCodeTime >= self.timeInterval {
                    self.progress = 0.00
                    self.generate()
                } else {
                    let time = UInt64(Date().timeIntervalSince1970) - self.requestCodeTime
                    self.progress = CGFloat(time) / CGFloat(self.timeInterval)
                    print("【 viewModel 】____【 AuthenticatorItem 】____【 startRequestCode 】____【 code = \(self.verificationCode) 】____【 progress = \(self.progress) 】")
                    AuthenticatorViewModel.shared.changeAuthenticatorItemFromUserdefault(self)
                }
            }
        }
    }
    
    func stopRequestCode() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
}
