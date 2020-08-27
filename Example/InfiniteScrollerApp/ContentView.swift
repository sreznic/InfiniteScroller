//
//  ContentView.swift
//  InfiniteScrollerApp
//
//  Created by sergey on 24.08.2020.
//  Copyright © 2020 com.SergeyReznichenko. All rights reserved.
//

import SwiftUI
import InfiniteScroller

struct ContentView: View {
    var items: [IntAndColor] = [IntAndColor(1, .yellow), IntAndColor(2, .red), IntAndColor(3, .green), IntAndColor(4, .blue), IntAndColor(5, .orange)]
    
    var direction: InfiniteDirection = .vertical(height: 70)
    @State var selected: IntAndColor = IntAndColor(3, .green)
    var body: some View {
        VStack {
            Text("selected: \(selected.int)").background(Color(selected.color))
            InfiniteScroller(direction: direction, items: items, selectedItem: $selected, visibleCells: 3, cellSpacing: 0) { item in
                VStack {
                    Image("largeImage")
                        .resizable()
                        .scaledToFit()
                    Text("\(item.int)")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(item.color))
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension InfiniteDirection {
    var isVertical: Bool {
        switch self {
        case .horizontal: return false
        case .vertical: return true
        }
    }
}

extension InfiniteDirection: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .horizontal(width: width):
            return "(horizontal width: \(width))"
        case let .vertical(height: height):
            return "(vertical height: \(height))"
        }
    }
}


struct IntAndColor: Equatable {
    var int: Int
    var color: UIColor
    
    init(_ int: Int, _ color: UIColor) {
        self.int = int
        self.color = color
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.int == rhs.int
    }
}
