//
//  PullToRefreshSettings.swift
//  POSInfiniteScroll
//
//  Created by Ion Postolachi on 12/23/19.
//

import UIKit

public protocol PullToRefreshSpinnerViewProtocol: SpinnerViewProtocol {
    var progress: CGFloat { get set }
    var isAnimating: Bool { get }
}

final class PullToRefreshSettings {
    var enabled: Bool = false
    var requestInProgress: Bool = false
    var isFromBeginToRefresh: Bool = false
    var completion: ((UIScrollView) -> Void)?
    var spinnerView: PullToRefreshSpinnerViewProtocol?
    var triggerOffset: CGFloat = 80
    var initialContentInset: UIEdgeInsets = .zero
    lazy var loaderView: UIView = createLoaderView()
    
    private func createLoaderView() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        return view
    }
}
