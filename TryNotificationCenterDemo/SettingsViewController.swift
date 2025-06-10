//
//  SettingsViewController.swift
//  TryNotificationCenterDemo
//
//  Created by mike liu on 2025/6/9.
//
import UIKit


// MARK: - 發送者與監聽者: 設定頁 (修改後版本)
class SettingsViewController: UIViewController {
    
    private let themeSwitch = UISwitch()
    private let switchLabel = UILabel()
    
    // 我們先預設一個目前的主題狀態
    private var currentTheme: Theme = .light

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // --- 步驟 1: 新增註冊監聽 ---
        // 讓設定頁自己也成為一個「聽眾」
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleThemeChange(_:)),
                                               name: .themeDidChangeNotification,
                                               object: nil)
        
        print("SettingsViewController: 我現在既是發送者，也是監聽者了。")
        
        // --- 步驟 2: 初始化時套用一次主題 ---
        loadAndApplyTheme()
    }
    
    private func setupUI() {
        switchLabel.text = "夜間模式"
        switchLabel.font = .systemFont(ofSize: 18)
        
        themeSwitch.addTarget(self, action: #selector(themeDidChange), for: .valueChanged)
        
        let stackView = UIStackView(arrangedSubviews: [switchLabel, themeSwitch])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func loadAndApplyTheme() {
        let savedThemeValue = UserDefaults.standard.string(forKey: UserDefaultsKeys.appTheme)
        let currentTheme = Theme(rawValue: savedThemeValue ?? "light") ?? .light
        applyTheme(currentTheme)
    }
    
    // --- 步驟 3: 新增處理通知的方法 ---
    @objc private func handleThemeChange(_ notification: Notification) {
        guard let theme = notification.userInfo?["theme"] as? Theme else { return }
        
        print("SettingsViewController: 我自己也收到了通知！新主題是 \(theme.rawValue)。")
        
        // 更新自己內部的狀態
        self.currentTheme = theme
        
        // 更新 UI
        // 因為發送和接收都在同一個物件，且都在主執行緒，這裡可以不用 DispatchQueue.main.async
        // 但為了養成好習慣，加上也無妨
        DispatchQueue.main.async {
            self.applyTheme(theme)
        }
    }
    
    // --- 步驟 4: 新增更新 UI 的方法 ---
    // 在 SettingsViewController.swift 中

    private func applyTheme(_ theme: Theme) {
        view.backgroundColor = theme.backgroundColor
        switchLabel.textColor = theme.textColor
        
        // --- 新增這行來同步開關狀態 ---
        themeSwitch.setOn(theme == .dark, animated: false)
    }
    
    @objc private func themeDidChange(sender: UISwitch) {
        let newTheme: Theme = sender.isOn ? .dark : .light
        
        // --- 步驟 1: 將新主題儲存到 UserDefaults ---
        // 我們儲存它的原始字串值 "dark" 或 "light"
        UserDefaults.standard.set(newTheme.rawValue, forKey: UserDefaultsKeys.appTheme)
        print("SettingsViewController: 新主題 \(newTheme.rawValue) 已儲存到 UserDefaults。")
        
        // --- 步驟 2: 發送通知 (維持不變) ---
        print("SettingsViewController: 準備發送通知...")
        let userInfo = ["theme": newTheme]
        NotificationCenter.default.post(name: .themeDidChangeNotification,
                                        object: nil,
                                        userInfo: userInfo)
    }
    
    // --- 步驟 5: 新增 deinit 來移除監聽 ---
    // 既然新增了 addObserver，就必須有 removeObserver
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("SettingsViewController 已銷毀，並移除了監聽。")
    }
    
    
}
