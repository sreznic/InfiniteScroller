//
//  SwiftuiCollection.swift
//  InfiniteLayout_Example
//
//  Created by sergey on 23.08.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import SwiftUI
import InfiniteLayout
import MapKit

struct _InfiniteScroller<Item: Equatable, Content: View>: UIViewControllerRepresentable {
    
    var items: [Item]
    @Binding var selectedItem: Item
    var configuration: InfiniteScrollerVCConfiguration
    var rowContent: (Item) -> Content


    func makeUIViewController(context: UIViewControllerRepresentableContext<_InfiniteScroller>) -> InfiniteScrollerVC<Item, Content> {
        let selectedIndex = items.firstIndex(where: { $0 == selectedItem })!
        let infiniteVC = InfiniteScrollerVC(configuration: configuration, items: items, selectedIndex: selectedIndex, rowContent: rowContent)
        infiniteVC.delegate = AnyInfiniteScrollerVCDelegate(delegate: context.coordinator)
        return infiniteVC
    }
    
    func updateUIViewController(_ uiViewController: InfiniteScrollerVC<Item, Content>, context: Context) {
        uiViewController.infiniteCollectionView.reloadData()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    
    final class Coordinator: NSObject, InfiniteScrollerVCDelegate {
        let InfiniteScroller: _InfiniteScroller
        
        init(_ InfiniteScroller: _InfiniteScroller) {
            self.InfiniteScroller = InfiniteScroller
        }
        
        func selectItem(_ item: Item) {
            InfiniteScroller.selectedItem = item
        }
    }
}

public struct InfiniteScroller<Item: Equatable, Content: View>: View {
    private let direction: InfiniteDirection
    private let rowContent: (Item) -> Content
    private let items: [Item]
    private let visibleCells: Int
    private let cellSpacing: CGFloat
    private let updating: Bool
    
    @Binding var selectedItem: Item
    
    /// - Parameter updating: if the property is true then it means that each visible cell will refresh its View after selectedItem changes. May be disabled to gain speed. Default false
    public init(direction: InfiniteDirection, items: [Item], selectedItem: Binding<Item>, visibleCells: Int, cellSpacing: CGFloat, updating: Bool = false, @ViewBuilder rowContent: @escaping (Item) -> Content) {
        self.direction = direction
        self.rowContent = rowContent
        self.items = items
        self._selectedItem = selectedItem
        self.cellSpacing = cellSpacing
        self.visibleCells = visibleCells
        self.updating = updating
    }
    public var body: some View {
        _InfiniteScroller(items: items, selectedItem: $selectedItem, configuration: configuration, rowContent: { item in
            self.rowContent(item)
        })
            .frame(width: width, height: height)
    }
    
    private var configuration: InfiniteScrollerVCConfiguration {
        let cellHeightOrWidth: CGFloat
        let direction: UICollectionView.ScrollDirection
        switch self.direction {
        case let .horizontal(width: width):
            cellHeightOrWidth = width
            direction = .horizontal
        case let .vertical(height: height):
            cellHeightOrWidth = height
            direction = .vertical
        }
        
        return .init(cellHeightOrWidth: cellHeightOrWidth, cellSpacing: cellSpacing, direction: direction, updatingVisibleCells: updating)
    }
    
    var width: CGFloat? {
        switch direction {
        case let .horizontal(width: width):
            return width * CGFloat(visibleCells)
        case .vertical:
            return nil
        }
    }
    
    var height: CGFloat? {
        switch direction {
        case .horizontal:
            return nil
        case let .vertical(height: height):
            return height * CGFloat(visibleCells)
        }
    }
}
