//
//  WaveView.swift
//  WaveViewTest
//
//  Created by 李品毅 on 2022/8/14.
//

import UIKit

// 波浪曲線公式：y = h * sin(a * x + b);
// h: 波浪高度， a: 波浪寬度係數， b： 波的x軸移動

// CADisplayLink: https://juejin.cn/post/7032818807651434509

// 波浪曲線動畫view
class WaveView: UIView {
    
    /// 波浪高度
    var waveHeight: CGFloat = 7
    
    /// 波浪寬度係數(數值越大，波浪越短越密集)
    var waveRate: CGFloat = 0.01
    
    /// 波浪移動速度(數值越大，移動越快)
    var waveSpeed: CGFloat = 0.05
    
    /// 第一個波浪顏色
    var firstWaveColor: UIColor = .green
    
    /// 第二個波浪顏色
    var secondWaveColor: UIColor = .red
    
    /// 波浪佔畫面的比例(高度)
    var progress: Double = 0.5
    
    /// 波浪移動完的y軸回傳值
    var closure: ((_ centerY: CGFloat)->())?
    
    // MARK: - 內部var
    /// 定時器
    private var displayLink: CADisplayLink?
    
    /// 第一個波浪
    private var firstWaveLayer: CAShapeLayer?
    
    /// 第二個波浪
    private var secondWaveLayer: CAShapeLayer?
    
    /// 波浪的x軸偏移量
    private var offset: CGFloat = 0
     
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWaveParame()
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initWaveParame()
    }
     
    // 组件初始化
    private func initWaveParame() {
        // 真实波浪配置
        firstWaveLayer = CAShapeLayer()
        var frame = bounds
        firstWaveLayer?.frame.origin.y = frame.size.height - waveHeight
        frame.size.height = waveHeight
        firstWaveLayer?.frame = frame
         
        // 阴影波浪配置
        secondWaveLayer = CAShapeLayer()
        secondWaveLayer?.frame.origin.y = frame.size.height - waveHeight
        frame.size.height = waveHeight
        secondWaveLayer?.frame = frame
         
        layer.addSublayer(secondWaveLayer!)
        layer.addSublayer(firstWaveLayer!)
    }
     
    // MARK: - 動畫開關
    /// 開始播放動畫
    func startWave() {
        // 設置定時器
        displayLink = CADisplayLink(target: self, selector: #selector(self.wave))
        displayLink?.preferredFramesPerSecond = 60 // 每秒幀率
        /*
        preferredFramesPerSecond 為可读可写属性，用来设置每秒刷新次数，默认值为屏幕最大帧率，目前是60。
        实际的屏幕帧率会和 preferredFramesPerSecond 有一定的出入，结果是由设置的值和屏幕最大帧率相互影响产生的。规则大概如下:
        如果屏幕最大帧率是60，实际帧率只能是15，20，30，60中的一种。如果设置大于60的值，屏幕实际帧率为60。如果设置的是26~35之间的值，实际帧率是30。如果设置为0，会使用最高帧率。
         */
        displayLink?.add(to: .current, forMode: .common)
    }
     
    /// 停止播放動畫
    func endWave() {
        // 結束定時器
        displayLink?.invalidate()
        displayLink = nil
//        displayLink?.remove(from: .current, forMode: .common)
    }
     
    /// 定時器事件（每一幀都會调用一次）
    @objc func wave() {
        // 波浪移動的關鍵：按照指定的速度偏移
        offset += waveSpeed
        drawWaveWater(waveLayer: firstWaveLayer, offset: offset, fillColor: firstWaveColor)
        drawWaveWater(waveLayer: secondWaveLayer, offset: offset - 5, fillColor: secondWaveColor)
    }
    
    /// 繪製波浪
    /// - Parameters:
    ///  - offset: x軸偏移量
    func drawWaveWater(waveLayer: CAShapeLayer?, offset: CGFloat, fillColor: UIColor) {

        /* 路徑從左下角開始 -> 左上波浪起點 -> 右上波浪終點 -> 右下角結束
         參考資料：https://www.796t.com/p/386071.html
         */
        
        let curvePath = UIBezierPath()
        // 左下角
        let startY = frame.size.height
        curvePath.move(to: CGPoint(x: 0, y: startY))
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        while x <= bounds.size.width {
            // 畫波浪曲线
            y = waveHeight * sin(x * waveRate + offset)
            // 這邊高度可以調整
            let position =  (1 - progress) * startY
            let realY = y + position
            curvePath.addLine(to: CGPoint(x: x, y: realY))
            // 增量越小，曲线越平滑
            x += 0.1
        }
        
        let midX = bounds.size.width * 0.5
        let midY = waveHeight * sin(midX * waveRate + offset)

        // 波浪移動完回傳位置
        if let closureBack = closure {
            closureBack(midY)
        }
        
        // 回到右下角
        curvePath.addLine(to: CGPoint(x: frame.size.width, y: startY))
        curvePath.close()
        waveLayer?.path = curvePath.cgPath
        waveLayer?.fillColor = fillColor.cgColor
    }
    
    deinit {
        reset()
    }

    private func reset() {
        if firstWaveLayer != nil {
            firstWaveLayer?.removeFromSuperlayer()
            firstWaveLayer = nil
        }
        if secondWaveLayer != nil {
            secondWaveLayer?.removeFromSuperlayer()
            secondWaveLayer = nil
        }
    }
}

