//
//  Collection+PullToRefresh.swift
//  InfiniteScroll
//
//  Created by Ion Postolachi on 12/22/19.
//  Copyright © 2019 Ion Postolachi. All rights reserved.
//

import UIKit

extension UITableView {
    public func addPullToRefresh(_ completion: @escaping (UITableView) -> Void) {
        let settings = pullToRefreshSettings[objectAddress] ?? PullToRefreshSettings()
        settings.enabled = true
        pullToRefreshSettings[objectAddress] = settings
        settings.completion = { scrollView in
            if let tableView = scrollView as? UITableView {
                completion(tableView)
            }
        }
    }
}

extension UICollectionView {
    public func addPullToRefresh(_ completion: @escaping (UICollectionView) -> Void) {
        if !canAddPullToRefresh() { return }
        let settings = pullToRefreshSettings[objectAddress] ?? PullToRefreshSettings()
        settings.enabled = true
        pullToRefreshSettings[objectAddress] = settings
        settings.completion = { scrollView in
            if let collectionView = scrollView as? UICollectionView {
                completion(collectionView)
            }
        }
    }
    
    public func reloadDataAndFinishPullToRefresh() {
        reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.finishPullToRefresh()
        }
    }
}
