//
//  SceneDelegate.swift
//  TryNotificationCenterDemo
//
//  Created by mike liu on 2025/6/9.
//

import UIKit

// MARK: - 場景設定
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // 建立三個不同的頁面
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "首頁", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "個人資料", image: UIImage(systemName: "person.fill"), tag: 1)
        
        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(title: "設定", image: UIImage(systemName: "gearshape.fill"), tag: 2)
        
        // 用一個 TabBarController 來管理這三個頁面
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeVC, profileVC, settingsVC]
        tabBarController.tabBar.backgroundColor = .secondarySystemBackground
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
