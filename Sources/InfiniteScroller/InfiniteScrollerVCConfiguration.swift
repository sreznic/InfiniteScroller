//
//  InfiniteScrollerVCConfiguration_.swift
//  InfiniteLayout_Example
//
//  Created by sergey on 23.08.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

struct InfiniteScrollerVCConfiguration {
    var cellHeightOrWidth: CGFloat
    var cellSpacing: CGFloat
    var direction: UICollectionView.ScrollDirection
    // It means that each visible cell will refresh its View after selectedItem changes. May be disabled to gain speed.
    var updatingVisibleCells: Bool
}
