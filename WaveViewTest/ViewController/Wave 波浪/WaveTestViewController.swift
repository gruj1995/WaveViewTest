//
//  WaveTestViewController.swift
//  WaveViewTest
//
//  Created by 李品毅 on 2022/8/14.
//

import UIKit

class WaveTestViewController: UIViewController {
    
    
    @IBOutlet weak var waveLoadingIndicator: WaveLoadingIndicator!
    
    @IBOutlet weak var waveView: WaveView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWaveView()
        setWaveLoadingIndicator()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setBorder(waveLoadingIndicator)
        setBorder(waveView)
    }
    
    private func setWaveView(){
        waveView.waveRate = 0.04 // 波浪寬度係數(值越大波浪越短越密集)
        waveView.waveHeight = 15 //波幅
        waveView.progress = 0.7 // 波浪佔畫面比例(高度)
        waveView.firstWaveColor = UIColor(hex: "#FF7473") // 第一個波浪顏色
        waveView.secondWaveColor = UIColor.red // 第二個波浪顏色
        waveView.startWave()
    }
    
    private func setWaveLoadingIndicator(){
        waveLoadingIndicator.progress = 0.7 // 波浪佔畫面比例(高度)
        waveLoadingIndicator.animationUnitTime = 0.08 // 重畫單位時間，值越小波浪移動越快
        waveLoadingIndicator.waveAmplitude = 29.0 //波幅
        waveLoadingIndicator.heavyColor = UIColor(hex: "#FF7473")
        waveLoadingIndicator.lightColor = .red
    }
    
    private func setBorder(_ view: UIView){
        view.layer.cornerRadius = view.bounds.height / 2
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
    }
}


extension UIColor{
    /// 用16進制色碼生成顏色，前面可帶入#符號
    convenience init(hex:String, alpha:CGFloat = 1.0) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt64 = 0 //color #999999 if string has wrong format

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt64(&rgbValue)
        }

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
