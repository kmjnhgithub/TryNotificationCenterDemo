//
//  Theme.swift
//  TryNotificationCenterDemo
//
//  Created by mike liu on 2025/6/9.
//

import UIKit

// MARK: - 核心：通知的名稱管理
// 將通知名稱統一定義在一個地方，是個非常好的習慣。
// 這樣可以避免在各處手動打字，減少因拼寫錯誤導致的 bug。
extension Notification.Name {
    static let themeDidChangeNotification = Notification.Name("com.TryNotificationCenterDemo.themeDidChangeNotification")
}

// MARK: - 主題枚舉
// 定義 App 支援的主題
enum Theme: String {
    case light
    case dark
    
    var backgroundColor: UIColor {
        switch self {
        case .light:
            return .white
        case .dark:
            return .black
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .light:
            return .black
        case .dark:
            return .white
        }
    }
}

struct UserDefaultsKeys {
    static let appTheme = "appTheme"
}
