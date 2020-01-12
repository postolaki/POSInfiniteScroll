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
        settings.initialContentInset = contentInset
        settings.requestInProgress = true
        settings.isFromBeginToRefresh = true
        pullToRefreshSettings[objectAddress] = settings
        
        addLoaderView(settings)
        pullToRefreshSpinnerView?.startAnimating()

        if let tableView = self as? UITableView {
            UIView.animate(withDuration: 0.3, animations: {
                guard !tableView.visibleCells.isEmpty else { return }
                let indexPath = IndexPath(row: 0, section: 0)
                tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }) { [weak self] _ in
                self?.animate(settings: settings, completion: { _ in completion?() })
            }
        } else if let collectionView = self as? UICollectionView {
            guard !collectionView.visibleCells.isEmpty else { return }
            UIView.animate(withDuration: 0.3, animations: {
                let indexPath = IndexPath(row: 0, section: 0)
                collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
            }) { [weak self] _ in
                self?.animate(settings: settings, completion: { _ in completion?() })
            }
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
        }) { _ in
            settings.isFromBeginToRefresh = false
            settings.requestInProgress = false
            completion?()
            settings.spinnerView?.stopAnimating()
        }
    }
    
    public func removePullToRefresh() {
        pullToRefreshSettings.removeValue(forKey: objectAddress)
        guard let settings = pullToRefreshSettings[objectAddress] else { return }
        removeLoaderView(settings)
    }
    
    func showPullToRefreshLoader(settings: PullToRefreshSettings) {
        guard contentOffsetY < 0, settings.enabled else { return }
        addLoaderView(settings)
        setLoaderViewHeight(settings)
        setSpinnerProgress(settings)
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
        let heightConstraint = settings.loaderView.constraints.first(where: { $0.identifier == "height" })
        var progress = (heightConstraint?.constant ?? 0) / settings.triggerOffset
        progress = min(progress, 1)
        if pullToRefreshSpinnerView?.isAnimating == false {
            settings.spinnerView?.progress = progress
            if progress == 1 {
                pullToRefreshSpinnerView?.startAnimating()
                vibrate()
            }
        }
    }
    
    private func sendCompletion(_ settings: PullToRefreshSettings) {
        let heightConstraint = settings.loaderView.constraints.first(where: { $0.identifier == "height" })
        let progress = (heightConstraint?.constant ?? 0) / settings.triggerOffset
        
        if min(progress, 1) == 1 && isDecelerating && !settings.requestInProgress {
            settings.requestInProgress = true
            contentInset.top += settings.triggerOffset
            settings.completion?(self)
        }
    }
    
    private func setLoaderViewHeight(_ settings: PullToRefreshSettings) {
        guard !settings.isFromBeginToRefresh else { return }
        let heightConstraint = settings.loaderView.constraints.first(where: { $0.identifier == "height" })
        heightConstraint?.constant = abs(contentOffsetY) - settings.initialContentInset.top
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
    
    func animate(settings: PullToRefreshSettings, completion: ((Bool) -> Void)? = nil) {
        let heightConstraint = settings.loaderView.constraints.first(where: { $0.identifier == "height" })
        heightConstraint?.constant = settings.triggerOffset
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.contentOffset.y -= settings.triggerOffset
            self?.contentInset.top += settings.triggerOffset
            self?.layoutIfNeeded()
        }) { [weak self] _ in
            self?.vibrate()
            completion?(true)
        }
    }
    
    private func vibrate() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
