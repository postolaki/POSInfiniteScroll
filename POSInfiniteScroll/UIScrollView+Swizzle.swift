//
//  UIScrollView+Swizzle.swift
//  InfiniteScroll
//
//  Created by Ion Postolachi on 12/22/19.
//  Copyright © 2019 Ion Postolachi. All rights reserved.
//

import UIKit

extension UIScrollView {
    @objc public static func swizzleContentOffset() {
        let originalSelector = #selector(getter: contentOffset)
        let swizzledSelector = #selector(getter: swizzledContentOffset)
        guard let swizzledMethod = class_getInstanceMethod(UIScrollView.self, swizzledSelector),
            let originalMethod = class_getInstanceMethod(UIScrollView.self, originalSelector) else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        DispatchQueue.once(token: "swizzledContentOffset") {
            UIScrollView.swizzleContentOffset()
        }
    }
    
    @objc private var swizzledContentOffset: CGPoint {
        get {
            let collectionView = self as? UICollectionView
            let collectionViewLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
            if self is UITableView || collectionViewLayout?.scrollDirection == .vertical {
                let translation = panGestureRecognizer.translation(in: superview)
                if translation.y < 0 { // infinite scroll
                    guard let settings = infiniteScrollSettings[objectAddress] else { return self.swizzledContentOffset }
                    showVerticalInfiniteScrollLoader(settings: settings)
                } else { // pull to refresh
                    guard let settings = pullToRefreshSettings[objectAddress] else { return self.swizzledContentOffset }
                    showPullToRefreshLoader(settings: settings)
                }
            } else if collectionViewLayout?.scrollDirection == .horizontal {
                guard let settings = infiniteScrollSettings[objectAddress] else { return self.swizzledContentOffset }
                showHorizontalInfiniteScrollLoader(settings: settings)
            }
            return self.swizzledContentOffset
        }
    }
    
    var contentOffsetX: CGFloat {
        get { return swizzledContentOffset.x }
    }
    
    var contentOffsetY: CGFloat {
        get { return swizzledContentOffset.y }
    }
    
    var objectAddress: String {
        return String(format: "%p", self)
    }
}

extension DispatchQueue {
    private static var _onceTracker = [String]()

    class func once(token: String, block: @escaping() -> Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }

        if _onceTracker.contains(token) {
            return
        }

        _onceTracker.append(token)
        block()
    }
}
