//
//  InfiniteScrollerVC.swift
//  InfiniteLayout_Example
//
//  Created by sergey on 23.08.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import InfiniteLayout
import UIKit
import SwiftUI

class InfiniteScrollerVC<Item, Content: View>: UIViewController, InfiniteCollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private var visibleCellsInfo = [(IndexPath, UIViewController)]()
    private var selectedIndex: Int
    let infiniteCollectionView = InfiniteCollectionView()
    let configuration: InfiniteScrollerVCConfiguration
    var delegate: AnyInfiniteScrollerVCDelegate<Item>?
    var items: [Item]
    var rowContent: (Item) -> Content
    
    init(configuration: InfiniteScrollerVCConfiguration, items: [Item], selectedIndex: Int, @ViewBuilder rowContent: @escaping (Item) -> Content) {
        self.configuration = configuration
        self.rowContent = rowContent
        self.items = items
        self.selectedIndex = selectedIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(infiniteCollectionView)
        infiniteCollectionView.translatesAutoresizingMaskIntoConstraints = false
        infiniteCollectionView.delegate = self
        infiniteCollectionView.dataSource = self
        infiniteCollectionView.infiniteDelegate = self
        infiniteCollectionView.backgroundView = .none
        infiniteCollectionView.backgroundColor = .clear
        view.backgroundColor = .clear
        NSLayoutConstraint.activate([
            infiniteCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            infiniteCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            infiniteCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            infiniteCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        infiniteCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: .cellIdentifier)
        
        self.view.backgroundColor = .clear
        let layout = InfiniteLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = configuration.cellSpacing
        layout.scrollDirection = configuration.direction
        infiniteCollectionView.collectionViewLayout = layout
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.infiniteCollectionView.scrollToItem(at: .init(row: self.selectedIndex, section: 0), at: self.infiniteCollectionView.infiniteLayout.scrollDirection == .vertical ? .centeredVertically : .centeredHorizontally, animated: false)
    }
    
    // MARK: - InfiniteCollectionViewDelegate
    func infiniteCollectionView(_ infiniteCollectionView: InfiniteCollectionView, didChangeCenteredIndexPath from: IndexPath?, to: IndexPath?) {
        guard let to = to else { return }
        let realIndexPath = infiniteCollectionView.indexPath(from: to)
        guard let item = items[safe: realIndexPath.row] else { return }
        delegate?.selectItem(item)
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .cellIdentifier, for: indexPath)
        let realIndexPath = infiniteCollectionView.indexPath(from: indexPath)
        let item = items[realIndexPath.row]
        let vc = UIHostingController(rootView: rowContent(item))
        addChild(vc)
        cell.backgroundView = vc.view
        visibleCellsInfo.append((realIndexPath, vc))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let realIndexPath = infiniteCollectionView.indexPath(from: indexPath)
        if let index = visibleCellsInfo.firstIndex(where: { $0.0 == realIndexPath }) {
            let vc = visibleCellsInfo[index].1
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
            visibleCellsInfo.remove(at: index)
        }
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat
        let height: CGFloat
        switch configuration.direction {
        case .horizontal:
            width = configuration.cellHeightOrWidth
            height = collectionView.frame.height
        case .vertical:
            width = collectionView.frame.width
            height = configuration.cellHeightOrWidth
        @unknown default:
            width = collectionView.frame.width
            height = configuration.cellHeightOrWidth
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.frame.height
    }
    
    
}

fileprivate extension String {
    static var cellIdentifier: String { "InfVCCellId" }
}
