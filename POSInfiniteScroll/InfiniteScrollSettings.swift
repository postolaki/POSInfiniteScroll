//
//  InfiniteScrollSettings.swift
//  InfiniteScroll
//
//  Created by Ion Postolachi on 12/23/19.
//  Copyright © 2019 Ion Postolachi. All rights reserved.
//

import UIKit

public protocol SpinnerViewProtocol: UIView {
    func startAnimating()
    func stopAnimating()
}

extension UIActivityIndicatorView: SpinnerViewProtocol {}

final class InfiniteScrollSettings {
    var enabled: Bool = false
    var requestInProgress: Bool = false
    var completion: ((UIScrollView) -> Void)?
    var triggerOffset: CGFloat = 0
    var spinnerView: SpinnerViewProtocol?
    lazy var loaderView: UIView = createLoaderView()
    var shouldRemoveInfiniteScrollHandler: () -> Bool = { return false }
    
    private func createLoaderView() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
}
