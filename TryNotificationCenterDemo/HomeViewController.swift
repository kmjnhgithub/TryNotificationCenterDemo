//
//  HomeViewController.swift
//  TryNotificationCenterDemo
//
//  Created by mike liu on 2025/6/9.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // *** 步驟 1: 註冊監聽 ***
        // 告訴通知中心：如果有人發送 "themeDidChangeNotification" 通知，請呼叫我的 handleThemeChange 方法
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleThemeChange(_:)),
                                               name: .themeDidChangeNotification,
                                               object: nil) // object 傳 nil 表示接收來自任何發送者的通知
        
        print("HomeViewController: 我已經準備好接收主題變更的通知了。")
        // --- 新增步驟: App 啟動時，從 UserDefaults 讀取主題來設定初始外觀 ---
        loadAndApplyTheme()
    }
    
    private func setupUI() {
        titleLabel.text = "這是首頁"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func loadAndApplyTheme() {
        // 從 UserDefaults 中用鑰匙讀取儲存的字串 ("light" or "dark")
        let savedThemeValue = UserDefaults.standard.string(forKey: UserDefaultsKeys.appTheme)
        
        // 如果讀取到的值是 nil (例如第一次開啟App)，就預設為 "light"
        // 再根據字串，初始化成我們的 Theme enum
        let currentTheme = Theme(rawValue: savedThemeValue ?? "light") ?? .light
        
        applyTheme(currentTheme)
    }

    // *** 步驟 2: 實作處理方法 ***
    // 這個方法必須加上 @objc
    @objc private func handleThemeChange(_ notification: Notification) {
        // 從通知的 userInfo 中安全地取出資料
        // 這一步是關鍵，也是 NotificationCenter 強大的地方
        guard let theme = notification.userInfo?["theme"] as? Theme else {
            print("HomeViewController: 收到了通知，但無法解析主題。")
            return
        }
        
        print("HomeViewController: 收到通知！新主題是 \(theme.rawValue)。正在切換到主執行緒更新 UI...")
        
        // *** 關鍵安全點：確保 UI 更新在主執行緒 ***
        DispatchQueue.main.async {
            self.applyTheme(theme)
        }
    }
    
    private func applyTheme(_ theme: Theme) {
        view.backgroundColor = theme.backgroundColor
        titleLabel.textColor = theme.textColor
    }

    // *** 步驟 3: 移除監聽 ***
    // 當這個物件被銷毀時，一定要移除監聽，否則會導致記憶體洩漏 (Memory Leak)
    deinit {
        NotificationCenter.default.removeObserver(self, name: .themeDidChangeNotification, object: nil)
        print("HomeViewController 已銷毀，並移除了主題變更的監聽。")
    }
}

