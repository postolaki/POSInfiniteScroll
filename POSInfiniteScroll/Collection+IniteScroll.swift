//
//  Collection+InfiniteScroll.swift
//  InfiniteScroll
//
//  Created by Ion Postolachi on 12/21/19.
//  Copyright © 2019 Ion Postolachi. All rights reserved.
//

import UIKit

extension UITableView {
    public func addInfiniteScroll(_ completion: @escaping (UITableView) -> Void) {
        let settings = infiniteScrollSettings[objectAddress] ?? InfiniteScrollSettings()
        settings.enabled = true
        infiniteScrollSettings[objectAddress] = settings
        settings.completion = { scrollView in
            if let tableView = scrollView as? UITableView {
                completion(tableView)
            }
        }
    }
}

extension UICollectionView {
    public func addInfiniteScroll(_ completion: @escaping (UICollectionView) -> Void) {
        let settings = infiniteScrollSettings[objectAddress] ?? InfiniteScrollSettings()
        settings.enabled = true
        infiniteScrollSettings[objectAddress] = settings
        settings.completion = { scrollView in
            if let collectionView = scrollView as? UICollectionView {
                completion(collectionView)
            }
        }
    }
    
    public func reloadDataAndFinishInfIniteScroll() {
        reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.finishInfiniteScroll()
        }
    }
}
