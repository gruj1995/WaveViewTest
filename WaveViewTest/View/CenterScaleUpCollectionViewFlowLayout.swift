//
//  LeftRightCollectionViewFlowLayout.swift
//  WaveViewTest
//
//  Created by 李品毅 on 2022/8/14.
//

import UIKit

final class CenterScaleUpCollectionViewFlowLayout: UICollectionViewFlowLayout{
    
    /// cell邊長
    private(set) var cellLength: CGFloat = 0
    
    /// cell放大倍數
    private(set) var expandScale: CGFloat = 0
    
    /// cell放大後的邊長
    var expandCellLength: CGFloat{
        return cellLength / expandScale
    }
    
    required init(cellLength: CGFloat, expandScale: CGFloat) {
        self.cellLength = cellLength
        self.expandScale = expandScale
        super.init()
        // Setting up the view can be done here
//        setupView()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented"); }
    
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        estimatedItemSize = .zero
        minimumInteritemSpacing = cellLength / 2 // 上下最小間距
        minimumLineSpacing = cellLength / 2 // 左右最小間距
        itemSize = CGSize(width: cellLength, height: cellLength)
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x + collectionView!.contentInset.left
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView!.bounds.size.width, height: collectionView!.bounds.size.height)
        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.x
            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        })
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
