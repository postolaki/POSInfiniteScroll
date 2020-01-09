//
//  CollectionViewCell.swift
//  InfiniteScroll
//
//  Created by Ion Postolachi on 12/21/19.
//  Copyright © 2019 Ion Postolachi. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var label: UILabel!
    
    func setup(with text: String) {
        label.text = text
    }
}
