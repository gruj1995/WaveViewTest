//
//  MainTabBarController.swift
//  WaveViewTest
//
//  Created by 李品毅 on 2022/8/14.
//

import UIKit

class MainTabBarController: UITabBarController{
    
    // MARK: - Properties
    /// 圖標被選中的顏色
    private var selectedColor:UIColor = .white
    /// 圖標未被選中的顏色
    private var normalColor:UIColor = .lightText
    /// tabBar的背景色
    private var backgroundColor:UIColor = .systemTeal
    /// tabBar樣式設置
    private var appearance = UITabBarAppearance()
    
    // MARK: - View Recycle
    override func viewDidLoad() {
        super.viewDidLoad()
  
        /// 消除tabBar邊框顏色
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.clear.cgColor
        
        setColor()
    }
    
    private func setColor(){
        
        if #available(iOS 13.0, *) {
            appearance.configureWithOpaqueBackground()

            ///如果有設置selected.iconColor or selected.titleTextAttributes 則會覆寫掉 tabBarMain.tintColor，
            ///否則系統預設係以 tabBarMain.tintColor 為主
            appearance.compactInlineLayoutAppearance.normal.iconColor = normalColor
            appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : normalColor]

            appearance.inlineLayoutAppearance.normal.iconColor = normalColor
            appearance.inlineLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor : normalColor,
                .font: UIFont.systemFont(ofSize: 16, weight: .regular)]

            appearance.stackedLayoutAppearance.normal.iconColor = normalColor
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor : normalColor,
                .font: UIFont.systemFont(ofSize: 16, weight: .regular)]

            /// tabBar 背景色
            appearance.backgroundColor =  backgroundColor
        }
        /// tabBar 背景色
        tabBar.barTintColor = backgroundColor
        /// tabbar 標籤未被選取時的顏色
        tabBar.unselectedItemTintColor = normalColor
        /// tabBar 標籤被選取時的顏色
        tabBar.tintColor = selectedColor

        ///Apply Appearance
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.setValue(appearance, forKey: "scrollEdgeAppearance")
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
