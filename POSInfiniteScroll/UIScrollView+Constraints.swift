//
//  UIScrollView+Constraints.swift
//  InfiniteScroll
//
//  Created by Ion Postolachi on 12/22/19.
//  Copyright © 2019 Ion Postolachi. All rights reserved.
//

import UIKit

extension UIScrollView {
    func setVerticalLoaderViewConstraints(_ loaderView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: loaderView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loaderView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loaderView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: loaderView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loaderView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: contentSize.height).isActive = true
        layoutIfNeeded()
    }
    
    func setHorizontalLoaderViewConstraints(_ loaderView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: loaderView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loaderView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loaderView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: loaderView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loaderView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: contentSize.width).isActive = true
        layoutIfNeeded()
    }
    
    func setPullToRefreshLoaderViewConstraints(_ loaderView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: loaderView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loaderView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        let heightConstraint = NSLayoutConstraint(item: loaderView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        heightConstraint.identifier = "height"
        heightConstraint.isActive = true
        NSLayoutConstraint(item: loaderView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loaderView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        layoutIfNeeded()
    }
    
    func setSpinnerViewConstraints(_ spinner: UIView, loaderView: UIView) {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: spinner, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: spinner.frame.width).isActive = true
        NSLayoutConstraint(item: spinner, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: spinner.frame.height).isActive = true
        NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: loaderView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: spinner, attribute: .centerY, relatedBy: .equal, toItem: loaderView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
}
