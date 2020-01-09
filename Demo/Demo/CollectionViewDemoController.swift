//
//  CollectionViewDemoController.swift
//  Demo
//
//  Created by Ion Postolachi on 12/21/19.
//  Copyright © 2019 Ion Postolachi. All rights reserved.
//

import Foundation
import UIKit
import POSInfiniteScroll

final class CollectionViewDemoController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private lazy var items: [String] = Array.randomElements
    private var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupPullToRefresh()
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CollectionViewCell")
        
        addInfiniteScroll()
    }
    
    private func setupPullToRefresh() {
        let lottieAnimationView = LottieAnimationView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        collectionView.pullToRefreshSpinnerView = lottieAnimationView
        collectionView.addPullToRefresh { [weak self] collectionView in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.page = 0
                self?.items = Array.randomElements
                collectionView.reloadDataAndFinishPullToRefresh()
                
                self?.addInfiniteScroll()
            }
        }
    }
    
    private func addInfiniteScroll() {
        let lottieAnimationView = LottieAnimationView(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
        collectionView.infiniteScrollSpinnerView = lottieAnimationView
        collectionView.addInfiniteScroll { [weak self] collectionView in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.page += 1
                self?.items += Array.randomElements
                collectionView.reloadDataAndFinishInfIniteScroll()
            }
        }
        
        collectionView.shouldRemoveInfiniteScrollHandler = { [weak self] in
            return self?.page == 3
        }
    }
}

extension CollectionViewDemoController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.setup(with: items[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2, height: 100)
    }
}
