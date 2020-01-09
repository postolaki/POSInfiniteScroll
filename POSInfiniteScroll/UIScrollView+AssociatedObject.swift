//
//  UIScrollView+AssociatedObject.swift
//  InfiniteScroll
//
//  Created by Ion Postolachi on 12/21/19.
//  Copyright © 2019 Ion Postolachi. All rights reserved.
//

import UIKit

extension UIScrollView {
    private struct AssociatedKeys {
        static var InfiniteScrollSettings = "InfiniteScrollSettings"
        static var PullToRefreshSettings = "PullToRefreshSettings"
    }
    
    var infiniteScrollSettings: [String: InfiniteScrollSettings] {
        get {
            let dict = objc_getAssociatedObject(self, &AssociatedKeys.InfiniteScrollSettings) as? [String: InfiniteScrollSettings]
            return dict ?? [:]
        }
        
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.InfiniteScrollSettings,
                newValue as [String: InfiniteScrollSettings],
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    var pullToRefreshSettings: [String: PullToRefreshSettings] {
        get {
            let dict = objc_getAssociatedObject(self, &AssociatedKeys.PullToRefreshSettings) as? [String: PullToRefreshSettings]
            return dict ?? [:]
        }
        
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.PullToRefreshSettings,
                newValue as [String: PullToRefreshSettings],
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    public var infiniteScrollSpinnerView: SpinnerViewProtocol? {
        get {
            return infiniteScrollSettings[objectAddress]?.spinnerView
        }
        
        set {
            let settings = infiniteScrollSettings[objectAddress] ?? InfiniteScrollSettings()
            infiniteScrollSettings[objectAddress] = settings
            infiniteScrollSettings[objectAddress]?.spinnerView = newValue
        }
    }
    
    public var pullToRefreshSpinnerView: PullToRefreshSpinnerViewProtocol? {
        get {
            return pullToRefreshSettings[objectAddress]?.spinnerView
        }
        
        set {
            let settings = pullToRefreshSettings[objectAddress] ?? PullToRefreshSettings()
            pullToRefreshSettings[objectAddress] = settings
            pullToRefreshSettings[objectAddress]?.spinnerView = newValue
        }
    }
    
    public var infiniteScrollTriggerOffset: CGFloat {
        get {
            return infiniteScrollSettings[objectAddress]?.triggerOffset ?? 0
        }
        
        set {
            let settings = infiniteScrollSettings[objectAddress] ?? InfiniteScrollSettings()
            infiniteScrollSettings[objectAddress] = settings
            infiniteScrollSettings[objectAddress]?.triggerOffset = newValue
        }
    }
    
    public var pullToRefreshTriggerOffset: CGFloat {
        get {
            return pullToRefreshSettings[objectAddress]?.triggerOffset ?? 80
        }
        
        set {
            let settings = pullToRefreshSettings[objectAddress] ?? PullToRefreshSettings()
            pullToRefreshSettings[objectAddress] = settings
            pullToRefreshSettings[objectAddress]?.triggerOffset = newValue
        }
    }
    
    public var shouldRemoveInfiniteScrollHandler: () -> Bool {
        get {
            return infiniteScrollSettings[objectAddress]?.shouldRemoveInfiniteScrollHandler ?? { return false }
        }
        
        set {
            let settings = infiniteScrollSettings[objectAddress] ?? InfiniteScrollSettings()
            infiniteScrollSettings[objectAddress] = settings
            infiniteScrollSettings[objectAddress]?.shouldRemoveInfiniteScrollHandler = newValue
        }
    }
}
