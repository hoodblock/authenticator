# authenticator
基于SwiftUI编写的，同时具备 基于时间的一次性密码（TOTP）认证器 和 密码管理器 功能，并将所有重要数据安全地保存在系统钥匙串中，为你的账户安全保驾护航
---

📊 界面预览
<h3></h3>
<p align="center">
  <img src="https://github.com/user-attachments/assets/d2268831-6488-46b3-a2ad-870c65ad45a0" width="180"/>
  <img src="https://github.com/user-attachments/assets/6f03b4d6-fc4c-49cb-a6ee-0a67132f4d37" width="180"/>
  <img src="https://github.com/user-attachments/assets/d915ff27-da80-4bec-abfd-77c35c041e71" width="180"/>
</p>

---

✨ 功能概览

- TOTP 双重认证器（2FA）

   - 支持 RFC 6238 标准的基于时间一次性密码（TOTP）。

   - 兼容 Google Authenticator、Authy 等常用 2FA 服务。

   - 支持多账号管理：你可以轻松管理不同平台的 TOTP，例如 GitHub、AWS、Google 等。

   - 支持自定义算法（SHA1、SHA256、SHA512）、密码位数（6/8位）、刷新时间间隔等高级选项。

   - 通过扫描二维码或手动输入密钥（Secret）添加账户。

- 密码管理器

   - 保存常用网站、服务的登录凭证（用户名、密码）。

   - 分组管理，方便快速找到所需密码。

- 安全存储

   - 采用系统自带钥匙串（Keychain）保存所有密钥和密码，充分利用操作系统级别的安全保障。

   - 本地存储，不上传任何密码或密钥至服务器，保障隐私。

---

## 🛠 启用 2FA 流程

### 📌 获取秘钥
- 在服务（例如 GitHub）中点击启用 2FA。
- 系统会生成一个绑定二维码，二维码内容形如：

  ```swift
  otpauth://totp/GitHub:YourName?secret=YOURSECRET&issuer=GitHub
  ```
- 使用 App 或任何支持 otpauth 的 Authenticator 扫描二维码，将 secret 保存到本地。

### ✅ 绑定确认
- App 和服务器（GitHub）分别使用相同的秘钥，基于 TOTP 算法各自生成验证码。
- 输入 Authenticator 中生成的验证码，GitHub 校验一致后，即完成绑定。

---

## 🧩 验证原理

### 🔑 验证码生成原理
- 使用 **当前时间戳**与**秘钥**进行 HMAC 计算：
  
   ```swift
  TOTP = HASH(SecretKey, floor(unixtime(now) / 30))
   
    - `unixtime(now)`：当前 Unix 时间戳。
    - `30`：时间间隔，表示验证码每 30 秒更新一次。
    - 动态截断 HMAC 结果，取模 10⁶ 得到 6 位验证码。
  ```

### ⏱ 为什么需要时间间隔
- 若不将时间分段，验证码每秒变化一次，会导致客户端和服务器生成的验证码永远无法匹配。
- 所以标准规定将时间按 30 秒分段。

### ⏲ 处理时间不同步
- RFC-6238 建议：服务器在校验时可接受当前、前一个、后一个时间步（即 ±30s 的容忍度），提高容错率。
- 手机校时不准会导致验证码生成错误，现代设备大多支持自动网络时间同步。

---

## 🛡 安全性分析

### ✅ 秘钥安全
- 秘钥保存在 Keychain，未在 App 文件中以明文形式存储，防止泄露。
- 启用 2FA 后，秘钥只需在设备和服务端保存一次，后续均为本地离线计算。

### 🚨 秘钥泄露风险
- 绑定时二维码被截屏、拍照、劫持。
- 手机丢失或 Authenticator 应用数据泄露。

### 🔓 破解可能性
- 验证码只有 6 位，理论上 10⁶ 种组合，但有效时间仅30秒且服务器有暴力保护措施，几乎不可能通过暴力破解。
- 要根据验证码逆推秘钥也几乎不可能实现。

---
