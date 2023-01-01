//
//
//  WaveLoadingIndicator.swift
//  WaveLoadingView
//
//  Created by lzy on 15/12/30.
//  Copyright © 2015年 lzy. All rights reserved.
//

import UIKit

//正弦函数公式  y = amplitude * sin((2 * π / term) * x +- phasePosition)

enum ShapeModel {
    case circle
    case rect
}

class WaveLoadingIndicator: UIView {

    let π = Double.pi
    
    // MARK: - 不可修改
    /// 波幅最小值
    static private let amplitude_min = 16.0
    
    /// 波幅可调节幅度
    static private let amplitude_span = 26.0
    
    /// 周期（在代码中重新计算）, recalculate in layoutSubviews
    private var term: Double = 60.0
    
    /// 相位必须为0(画曲线机制局限), phase Must be 0
    private let phasePosition = 0.0
    
    /// 波幅
    private var amplitude = 29.0
    
    /// X轴所在的Y坐标（在代码中重新计算）, where the x axis of wave position
    private var position = 40.0
    
    /// 波浪移动的单位跨度，数值越大波浪移动越快，数值过大会出现不连续动画现象
    private let waveMoveSpan = 5.0
    
    private var waving: Bool = true
    
    class var amplitudeMin: Double {
        get { return amplitude_min }
    }
    
    class var amplitudeSpan: Double {
        get { return amplitude_span }
    }
    
    // MARK: - 可修改
    /// X坐标起点, the x origin of wave
    var originX = 0.0
    
    /// 循环次数。在控件宽度范围内，该正弦函数图形循环的次数，数值越大控件范围内看见的正弦函数图形周期数越多，波长约短波浪也越陡。 num of circulation
    var cycle: Double = 1.0
    
    /// 第一個波浪顏色
    var heavyColor = UIColor(red: 38/255.0, green: 227/255.0, blue: 198/255.0, alpha: 1.0)
    
    /// 第二個波浪顏色
    var lightColor = UIColor(red: 121/255.0, green: 248/255.0, blue: 221/255.0, alpha: 1.0)
    
    /// 重画单位时间，数值越小，重画速度越快频率越大 redraw unit time
    var animationUnitTime = 0.08
    
    /// 波浪佔畫面的比例(高度)
    var progress: Double = 0.5 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// 波幅
    var waveAmplitude: Double {
        get { return amplitude }
        set {
            amplitude = newValue
            self.setNeedsDisplay()
        }
    }

    var isShowProgressText = true
    
    var shapeModel:ShapeModel = .circle

    // MARK: 原本的
    //if use not in xib, create an func init
    override func awakeFromNib() {
        animationWave()
        self.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        animationWave()
        self.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
    }
    
    override func draw(_ rect: CGRect) {
        position =  (1 - progress) * Double(rect.height)

        //circle clip
        clipWithCircle()

        //draw wave
        drawWaveWater(originX: originX - term / 5, fillColor: lightColor)
        drawWaveWater(originX: originX, fillColor: heavyColor)

        //Let clipCircle above the waves
//        clipWithCircle()

        //draw the tip text of progress
        if isShowProgressText {
//            drawProgressText()
        }
    }
    
    private func drawWave(){
        position =  (1 - progress) * Double(frame.height)

        //circle clip
        clipWithCircle()

        //draw wave
        drawWaveWater(originX: originX - term / 5, fillColor: lightColor)
        drawWaveWater(originX: originX, fillColor: heavyColor)

        //Let clipCircle above the waves
//        clipWithCircle()

        //draw the tip text of progress
        if isShowProgressText {
//            drawProgressText()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //计算周期calculate the term
        term = Double(self.bounds.size.width) / cycle
//        self.layer.cornerRadius = shapeModel == .circle ? self.bounds.height / 2 : 0
    }

    override func removeFromSuperview() {
        super.removeFromSuperview()
        waving = false
    }
    
    func clipWithCircle() {
        self.clipsToBounds = shapeModel == .circle
    }
    
    
    func drawWaveWater(originX: Double, fillColor: UIColor) {
        let curvePath = UIBezierPath()
        curvePath.move(to: CGPoint(x: originX, y: position))
        
        //循环，画波浪wave path
        var tempPoint = originX
        
        for _ in 1...rounding(value: 4 * cycle) {
            //(2 * cycle)即可充满屏幕，即一个循环,为了移动画布使波浪移动，我们要画两个循环
            curvePath.addQuadCurve(to: keyPoint(x: tempPoint + term / 2, originX: originX), controlPoint: keyPoint(x: tempPoint + term / 4, originX: originX))
            tempPoint += term / 2
        }
        
        //close the water path
        curvePath.addLine(to: CGPoint(x: curvePath.currentPoint.x, y: self.bounds.size.height))
        curvePath.addLine(to: CGPoint(x: CGFloat(originX), y: self.bounds.size.height))
        curvePath.close()

        fillColor.setFill()
        curvePath.lineWidth = 10
        curvePath.fill()
    }
    
    
//    func drawProgressText() {
//        //Avoid negative
//        var validProgress = progress * 100
//        validProgress = validProgress < 1 ? 0 : validProgress
//
//        let progressText = (NSString(format: "%.0f", validProgress) as String) + "%"
//
//        var attribute: [String : AnyObject]!
//        if progress > 0.45 {
//            attribute = [NSFontAttributeName : UIFont.systemFontOfSize(progressTextFontSize), NSForegroundColorAttributeName : UIColor.whiteColor()]
//        } else {
//            attribute = [NSFontAttributeName : UIFont.systemFontOfSize(progressTextFontSize), NSForegroundColorAttributeName : heavyColor]
//        }
//
//        let textSize = progressText.sizeWithAttributes(attribute)
//        let textRect = CGRectMake(self.bounds.width/2 - textSize.width/2, self.bounds.height/2 - textSize.height/2, textSize.width, textSize.height)
//
//        progressText.drawInRect(textRect, withAttributes: attribute)
//    }

    func animationWave() {
        DispatchQueue.global(qos: .default).async { [weak self]() -> Void in
            guard let self = self else {return}
            let tempOriginX = self.originX
            while self.waving {
                if self.originX <= tempOriginX - self.term {
                    self.originX = tempOriginX - self.waveMoveSpan
                } else {
                    self.originX -= self.waveMoveSpan
                }
                DispatchQueue.main.async {() -> Void in
                    self.setNeedsDisplay()
                }
                Thread.sleep(forTimeInterval: self.animationUnitTime)
            }
        }
    }
    
    //determine the key point of curve
    func keyPoint(x: Double, originX: Double) -> CGPoint {
        //x为当前取点x坐标，columnYPoint的参数为相对于正弦函数原点的x坐标
        return CGPoint(x: x, y: columnYPoint(x: x - originX))
    }
    
    func columnYPoint(x: Double) -> Double {
        //三角正弦函数
        let result = amplitude * sin((2 * π / term) * x + phasePosition)
        return result + position
    }
    
    //四舍五入
    func rounding(value: Double) -> Int {
        let tempInt = Int(value)
        let tempDouble = Double(tempInt) + 0.5
        if value > tempDouble {
            return tempInt + 1
        } else {
            return tempInt
        }
    }
}
