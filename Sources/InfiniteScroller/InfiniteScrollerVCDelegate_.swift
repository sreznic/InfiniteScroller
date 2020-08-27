//
//  InfiniteScrollerVCDelegate.swift
//  InfiniteLayout_Example
//
//  Created by sergey on 23.08.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

protocol InfiniteScrollerVCDelegate: AnyObject {
    associatedtype Item
    func selectItem(_ item: Item)
}

class AnyInfiniteScrollerVCDelegate<Item>: InfiniteScrollerVCDelegate {
    private let _selectItem: (Item) -> Void
    init<Delegate: InfiniteScrollerVCDelegate>(delegate: Delegate) where Delegate.Item == Item {
        self._selectItem = delegate.selectItem
    }
    
    func selectItem(_ item: Item) {
        _selectItem(item)
    }
}
