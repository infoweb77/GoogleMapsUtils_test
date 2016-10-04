//
//  GQTPointQuadTree.swift
//  GoogleMapsUtils_test
//
//  Created by alex on 03/10/16.
//  Copyright © 2016 alex. All rights reserved.
//

import Foundation

final class GQTPointQuadTree {
    
    private var _bounds: GQTBounds
    private var _root: GQTPointQuadTreeChild!
    private var _count: Int = 0
    
    var count: Int {
        return _count
    }
    
    convenience init() {
        self.init(bounds: GQTBounds(minX: -1, minY: -1, maxX: 1, maxY: 1))
    }
    
    init(bounds: GQTBounds) {
        _bounds = bounds
        self.clear()
    }
    
    func add(item: GQTPointQuadTreeItem) -> Bool {
        let point = item.point
        
        guard _bounds.contains(point) else {
            return false
        }
        
        _root.add(item, withOwnBounds: _bounds, atDepth: 0)
        _count += 1
        
        return true
    }
    
    func remove(item: GQTPointQuadTreeItem) -> Bool {
        let point = item.point
        
        guard _bounds.contains(point) else {
            return false
        }
        
        let wasRemoved = _root.remove(item, withOwnBounds: _bounds)
        
        if wasRemoved {
            _count -= 1
        }
        
        return wasRemoved
    }
    
    func search(bounds: GQTBounds) -> NSArray {
        let results = NSMutableArray()
        _root.search(bounds, ownBounds: _bounds, accumulator: results)
        return results
    }
    
    func clear() {
        _root = GQTPointQuadTreeChild()
        _count = 0
    }
    
}
