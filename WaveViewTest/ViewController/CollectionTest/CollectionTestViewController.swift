//
//  CollectionTestViewController.swift
//  WaveViewTest
//
//  Created by 李品毅 on 2022/8/14.
//

import UIKit

// 居中cell放大的collectionView
// https://medium.com/@sh.soheytizadeh/zoom-uicollectionview-centered-cell-swift-5-e63cad9bcd49

class CollectionTestViewController: UIViewController {
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var collectionView: UICollectionView!

    private var centerCollectionViewFlowLayout: CenterScaleUpCollectionViewFlowLayout!
    
    let count = 3
    
    private var cellLength: CGFloat = WINDOW_WIDTH * 0.35
    private var centerCell: CircleCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        
        pageControl.numberOfPages = count
        pageControl.currentPageIndicatorTintColor = UIColor(hex: "#828282")
        pageControl.pageIndicatorTintColor = UIColor(hex: "#E0E0E0")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let layoutMargins: CGFloat = collectionView.layoutMargins.left +  collectionView.layoutMargins.right
        let sideInset = (WINDOW_WIDTH / 2) - layoutMargins - (centerCollectionViewFlowLayout.expandCellLength * 0.5)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    private func setCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        self.centerCollectionViewFlowLayout = CenterScaleUpCollectionViewFlowLayout(cellLength: self.cellLength, expandScale: 1.33)
        collectionView.collectionViewLayout = centerCollectionViewFlowLayout
    }
}

let WINDOW_WIDTH = UIScreen.main.bounds.width;
let WINDOW_HEIGHT = UIScreen.main.bounds.height;

// MARK: - Extension UICollectionViewDataSource
extension CollectionTestViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircleCell.reuseIdentifier, for: indexPath) as? CircleCell else {
            return UICollectionViewCell()
        }
        cell.setup(scale: centerCollectionViewFlowLayout.expandScale)
        return cell
    }
}

// MARK: - Extension UICollectionViewDelegate
extension CollectionTestViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

// MARK: - Extesion UIScrollViewDelegate
extension CollectionTestViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else {return}
        
        let size = collectionView.frame.size
        // 取得中心cell的中心點
        let centerPoint = CGPoint(
            x: size.width / 2 + scrollView.contentOffset.x,
            y: size.height / 2 + scrollView.contentOffset.y)
        
        if let indexPath = collectionView.indexPathForItem(at: centerPoint),
           self.centerCell == nil{
            self.centerCell = collectionView.cellForItem(at: indexPath) as? CircleCell
            self.centerCell?.transformToLarge()
        }
        
        /// 如果是中心cell
        if let cell = centerCell{
            let offsetX = centerPoint.x - cell.center.x
            // 超出中央範圍回歸正常大小
            let edge: CGFloat = centerCollectionViewFlowLayout.cellLength / 3
            if offsetX < -edge || offsetX > edge {
                cell.transformToStandard() // reset the cell size
                self.centerCell = nil
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 根據滑動的位置，計算頁數
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = currentPage
    }
}
