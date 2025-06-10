//
//  ProfileViewController.swift
//  TryNotificationCenterDemo
//
//  Created by mike liu on 2025/6/9.
//
import UIKit

class ProfileViewController: UIViewController {
    
    private let profileLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // 同樣註冊監聽
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleThemeChange(_:)),
                                               name: .themeDidChangeNotification,
                                               object: nil)
        print("ProfileViewController: 我也準備好接收主題變更的通知了。")
        loadAndApplyTheme()
    }
    
    private func setupUI() {
        profileLabel.text = "這是個人資料頁"
        profileLabel.font = .systemFont(ofSize: 24, weight: .bold)
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileLabel)
        
        NSLayoutConstraint.activate([
            profileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // 新增一個讀取和套用主題的方法
    private func loadAndApplyTheme() {
        let savedThemeValue = UserDefaults.standard.string(forKey: UserDefaultsKeys.appTheme)
        let currentTheme = Theme(rawValue: savedThemeValue ?? "light") ?? .light
        applyTheme(currentTheme)
    }
    
    @objc private func handleThemeChange(_ notification: Notification) {
        guard let theme = notification.userInfo?["theme"] as? Theme else {
            print("ProfileViewController: 收到了通知，但無法解析主題。")
            return
        }
        
        print("ProfileViewController: 收到通知！新主題是 \(theme.rawValue)。正在切換到主執行緒更新 UI...")
        
        DispatchQueue.main.async {
            self.applyTheme(theme)
        }
    }
    
    private func applyTheme(_ theme: Theme) {
        view.backgroundColor = theme.backgroundColor
        profileLabel.textColor = theme.textColor
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .themeDidChangeNotification, object: nil)
        print("ProfileViewController 已銷毀，並移除了主題變更的監聽。")
    }
}
