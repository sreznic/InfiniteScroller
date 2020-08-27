//
//  Array+SafeIndex.swift
//  InfiniteLayout_Example
//
//  Created by sergey on 24.08.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= startIndex, index < endIndex else {
            return nil
        }
        return self[index]
    }
}
