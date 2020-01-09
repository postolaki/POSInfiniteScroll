//
//  UIScrollView+PullToRefresh.swift
//  PullToRefresh
//
//  Created by Ion Postolachi on 12/22/19.
//  Copyright © 2019 Ion Postolachi. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    public func beginPullToRefresh(_ completion: (() -> Void)? = nil) {
        if !canAddPullToRefresh() { return }
        let settings = pullToRefreshSettings[objectAddress] ?? PullToRefreshSettings()
        pullToRefreshSettings[objectAddress] = settings
        
        settings.requestInProgress = true
        addLoaderView(settings)
        let heightConstraint = settings.loaderView.constraints.first(where: { $0.identifier == "height" })
        heightConstraint?.constant = settings.triggerOffset
        pullToRefreshSpinnerView?.startAnimating()

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.contentOffset.y -= settings.triggerOffset
            self?.contentInset.top += settings.triggerOffset
        }) { _ in
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            completion?()
        }
    }
    
    public func finishPullToRefresh(_ completion: (() -> Void)? = nil) {
        if !canAddPullToRefresh() { return }
        guard let settings = pullToRefreshSettings[objectAddress] else { return }
        let heightConstraint = settings.loaderView.constraints.first(where: { $0.identifier == "height" })
        heightConstraint?.constant = 0
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.contentInset.top -= settings.triggerOffset
            self?.layoutIfNeeded()
        }) { [weak self] _ in
            settings.requestInProgress = false
            self?.removeLoaderView(settings)
            completion?()
        }
    }
    
    public func removePullToRefresh() {
        pullToRefreshSettings.removeValue(forKey: objectAddress)
    }
    
    func showPullToRefreshLoader(settings: PullToRefreshSettings) {
        guard contentOffsetY < 0, settings.enabled else {
            let translation = panGestureRecognizer.translation(in: superview)
            if !isTracking && translation.y > 0 {
                removeLoaderView(settings)
            }
            return
        }
        addLoaderView(settings)
        setLoaderViewHeight(settings)
        setSpinnerProgress(settings)
        startAnimate(settings)
        sendCompletion(settings)
    }
    
    private func addLoaderView(_ settings: PullToRefreshSettings) {
        guard settings.loaderView.superview == nil else { return }
        addSubview(settings.loaderView)
        setPullToRefreshLoaderViewConstraints(settings.loaderView)
        let spinnerView: PullToRefreshSpinnerViewProtocol
        if let _spinnerView = pullToRefreshSpinnerView {
            spinnerView = _spinnerView
        } else {
            spinnerView = DefaultPullToRefreshSpinnerView()
            pullToRefreshSpinnerView = spinnerView
        }
        settings.loaderView.addSubview(spinnerView)
        spinnerView.progress = 0
        setSpinnerViewConstraints(spinnerView, loaderView: settings.loaderView)
    }
    
    private func setSpinnerProgress(_ settings: PullToRefreshSettings) {
        if !(pullToRefreshSpinnerView?.isAnimating ?? false) {
            let progress = abs(contentOffsetY) / settings.triggerOffset
            settings.spinnerView?.progress = progress
        }
    }
    
    private func startAnimate(_ settings: PullToRefreshSettings) {
        if abs(contentOffsetY) >= settings.triggerOffset && !(pullToRefreshSpinnerView?.isAnimating ?? false) {
            pullToRefreshSpinnerView?.startAnimating()
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
    
    private func sendCompletion(_ settings: PullToRefreshSettings) {
        if !isTracking && abs(contentOffsetY) > settings.triggerOffset && !settings.requestInProgress {
            settings.requestInProgress = true
            contentInset.top += settings.triggerOffset
            let heightConstraint = settings.loaderView.constraints.first(where: { $0.identifier == "height" })
            heightConstraint?.constant = settings.triggerOffset
            settings.completion?(self)
        }
    }
    
    private func setLoaderViewHeight(_ settings: PullToRefreshSettings) {
        guard isTracking else { return }
        let heightConstraint = settings.loaderView.constraints.first(where: { $0.identifier == "height" })
        heightConstraint?.constant = abs(contentOffsetY) - contentInset.top
    }
    
    private func removeLoaderView(_ settings: PullToRefreshSettings) {
        settings.spinnerView?.stopAnimating()
        if settings.spinnerView is DefaultPullToRefreshSpinnerView {
            settings.spinnerView?.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        }
        settings.loaderView.constraints.forEach { $0.isActive = false }
        settings.loaderView.removeFromSuperview()
    }
    
    func canAddPullToRefresh() -> Bool {
        let collectionView = self as? UICollectionView
        let collectionViewLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        return self is UITableView || collectionViewLayout?.scrollDirection == .vertical
    }
}
