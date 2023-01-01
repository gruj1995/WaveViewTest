//
//  TestPageViewController.swift
//  WaveViewTest
//
//  Created by 李品毅 on 2022/8/15.
//

import UIKit

class TestPageViewController: UIPageViewController{

    var selectedPage: Int = 0
    var pageCount: Int = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
    }
    
    func setupViewController(page: Int) -> UIViewController?{
        guard page >= 0 && page <= pageCount else{
            return nil
        }
        switch page{
        case 0:
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PieSheetViewController") as? PieSheetViewController else {
                return nil
            }
            vc.page = page
            return vc
//        case 1:
        default:
            return nil
        }
    }
    
}

extension TestPageViewController: UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !finished{
            return
        }
        
        if let pieSheetVC = viewControllers?.first as? PieSheetViewController,
           let page = pieSheetVC.page{
            self.selectedPage = page
        }
        
    }
}

extension TestPageViewController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return setupViewController(page: selectedPage - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return setupViewController(page: selectedPage + 1)
    }
}
