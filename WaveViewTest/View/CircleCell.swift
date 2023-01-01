//
//  CircleCell.swift
//  WaveViewTest
//
//  Created by 李品毅 on 2022/8/14.
//

import UIKit

class CircleCell: UICollectionViewCell {
    
    @IBOutlet weak var circleView: UIView!
    
    class var reuseIdentifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    private var scale: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        circleView.layer.borderWidth = 2
        circleView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleView.layoutIfNeeded()
        circleView.layer.cornerRadius = circleView.bounds.height / 2
    }
    
    func setup(scale: CGFloat){
        self.scale = scale
    }
    
    // 放大cell ()
    func transformToLarge(){
        UIView.animate(withDuration: 0.2){
            self.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
            self.layer.opacity = 1
        }
    }
    
    // 讓cell變回正常大小
    func transformToStandard(){
        UIView.animate(withDuration: 0.2){
            self.transform = CGAffineTransform.identity // 沒有套用任何效果
            self.layer.opacity = 0.5
        }
    }
    
}
