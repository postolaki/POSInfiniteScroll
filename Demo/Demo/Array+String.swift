//
//  Array+String.swift
//  Demo
//
//  Created by Ion Postolachi on 12/21/19.
//  Copyright © 2019 Ion Postolachi. All rights reserved.
//

import Foundation

extension Array where Element == String {
    static var randomElements: [String] {
        return (0 ..< 20).map { _ in randomString(length: 10) }
    }
    
    private static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0 ..< length).compactMap{ _ in letters.randomElement() })
    }
}
