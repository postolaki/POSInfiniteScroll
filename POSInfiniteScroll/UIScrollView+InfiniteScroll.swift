//
//  UIScrollView+InfiniteScroll.swift
//  InfiniteScroll
//
//  Created by Ion Postolachi on 12/21/19.
//  Copyright © 2019 Ion Postolachi. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    public func finishInfiniteScroll(_ completion: (() -> Void)? = nil) {
        guard let settings = infiniteScrollSettings[objectAddress] else { return }
        var contentInset = self.contentInset
        let collectionView = self as? UICollectionView
        let collectionViewLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        if self is UITableView || collectionViewLayout?.scrollDirection == .vertical {
            contentInset.bottom -= settings.loaderView.frame.height
        } else {
            contentInset.right -= settings.loaderView.frame.width
        }
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.contentInset = contentInset
        }) { [weak self] _ in
            self?.removeLoaderView(settings, completion: completion)
        }
    }
    
    public func removeInfiniteScroll() {
        infiniteScrollSettings.removeValue(forKey: objectAddress)
    }
    
    func showVerticalInfiniteScrollLoader(settings: InfiniteScrollSettings) {
        let c1 = contentSize.height >= frame.height
        let c2 = contentOffsetY + settings.triggerOffset > contentSize.height - frame.height
        if c1 && c2 && !settings.requestInProgress && settings.enabled {
            settings.requestInProgress = true
            addSubview(settings.loaderView)
            setVerticalLoaderViewConstraints(settings.loaderView)
            let spinnerView: SpinnerViewProtocol
            if let _spinnerView = settings.spinnerView {
                spinnerView = _spinnerView
            } else {
                spinnerView = UIActivityIndicatorView(style: .gray)
                settings.spinnerView = spinnerView
            }
            settings.loaderView.addSubview(spinnerView)
            setSpinnerViewConstraints(spinnerView, loaderView: settings.loaderView)
            spinnerView.startAnimating()
            contentInset.bottom += settings.loaderView.frame.height
            settings.completion?(self)
        }
    }
    
    func showHorizontalInfiniteScrollLoader(settings: InfiniteScrollSettings) {
        let c1 = contentSize.width >= frame.width
        let c2 = contentOffsetX + infiniteScrollTriggerOffset > contentSize.width - frame.width
        if c1 && c2 && !settings.requestInProgress && settings.enabled {
            settings.requestInProgress = true
            addSubview(settings.loaderView)
            setHorizontalLoaderViewConstraints(settings.loaderView)
            let spinnerView: SpinnerViewProtocol
            if let _spinnerView = settings.spinnerView {
                spinnerView = _spinnerView
            } else {
                spinnerView = UIActivityIndicatorView(style: .gray)
                settings.spinnerView = spinnerView
            }
            settings.loaderView.addSubview(spinnerView)
            setSpinnerViewConstraints(spinnerView, loaderView: settings.loaderView)
            spinnerView.startAnimating()
            contentInset.right += settings.loaderView.frame.width
            settings.completion?(self)
        }
    }
    
    private func removeLoaderView(_ settings: InfiniteScrollSettings, completion: (() -> Void)?) {
        settings.requestInProgress = false
        settings.spinnerView?.stopAnimating()
        settings.spinnerView?.removeFromSuperview()
        settings.loaderView.constraints.forEach { $0.isActive = false }
        settings.loaderView.removeFromSuperview()
        completion?()
        
        if settings.shouldRemoveInfiniteScrollHandler() {
            self.infiniteScrollSettings.removeValue(forKey: self.objectAddress)
        }
    }
}
