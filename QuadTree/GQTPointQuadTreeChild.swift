//
//  GQTPointQuadTreeChild.swift
//  GoogleMapsUtils_test
//
//  Created by alex on 03/10/16.
//  Copyright © 2016 alex. All rights reserved.
//

import Foundation

final class GQTPointQuadTreeChild: NSObject {
    
    let kMaxElements = 64
    let kMaxDepth = 30
    
    /** Top Right child quad. Nil until this node is split. */
    private var _topRight: GQTPointQuadTreeChild?
    /** Top Left child quad. Nil until this node is split. */
    private var _topLeft: GQTPointQuadTreeChild?
    /** Bottom Right child quad. Nil until this node is split. */
    private var _bottomRight: GQTPointQuadTreeChild?
    /** Bottom Left child quad. Nil until this node is split. */
    private var _bottomLeft: GQTPointQuadTreeChild?
    
    private var _items: [GQTPointQuadTreeItem]?
    
    override init() {
        _items = []
    }
    
    func add(item: GQTPointQuadTreeItem, withOwnBounds bounds: GQTBounds,
             atDepth depth: Int) {
        
        if let items = _items where items.count >= kMaxElements && depth < kMaxDepth {
            self.splitWithOwnBounds(bounds, atDepth: depth)
        }
        
        if let topRight = _topRight {
            let itemPoint = item.point
            let midPoint = bounds.midPoint
            
            if itemPoint.y > midPoint.y {
                if itemPoint.x > midPoint.x {
                    topRight.add(item, withOwnBounds: GQTPointQuadTreeChild.boundsTopRightChildQuadBounds(bounds), atDepth: depth + 1)
                }
                else {
                    _topLeft?.add(item, withOwnBounds: GQTPointQuadTreeChild.boundsTopLeftChildQuadBounds(bounds), atDepth: depth + 1)
                }
            }
            else {
                if itemPoint.x > midPoint.x {
                    _bottomRight?.add(item, withOwnBounds: GQTPointQuadTreeChild.boundsBottomRightChildQuadBounds(bounds), atDepth: depth + 1)
                }
                else {
                    _bottomLeft?.add(item, withOwnBounds: GQTPointQuadTreeChild.boundsBottomLeftChildQuadBounds(bounds), atDepth: depth+1)
                }
            }
        }
        else {
            _items!.append(item)
        }
    }
    
    func splitWithOwnBounds(ownBounds: GQTBounds, atDepth depth: Int) {
        assert(_items != nil)
        
        _topRight    = GQTPointQuadTreeChild()
        _topLeft     = GQTPointQuadTreeChild()
        _bottomRight = GQTPointQuadTreeChild()
        _bottomLeft  = GQTPointQuadTreeChild()
        
        let items = _items!
        self._items = nil
        
        for item in items {
            self.add(item, withOwnBounds: ownBounds, atDepth: depth)
        }
    }
    
    func remove(item: GQTPointQuadTreeItem, withOwnBounds bounds: GQTBounds) -> Bool {
        
        if let topRight = _topRight {
            let itemPoint = item.point
            let midPoint = bounds.midPoint
            
            if itemPoint.y > midPoint.y {
                if itemPoint.x > midPoint.x {
                    return topRight.remove(item, withOwnBounds: GQTPointQuadTreeChild.boundsTopRightChildQuadBounds(bounds))
                }
                else {
                    return _topLeft!.remove(item, withOwnBounds: GQTPointQuadTreeChild.boundsTopLeftChildQuadBounds(bounds))
                }
            }
            else {
                if itemPoint.x > midPoint.x {
                    return _bottomRight!.remove(item, withOwnBounds: GQTPointQuadTreeChild.boundsBottomRightChildQuadBounds(bounds))
                }
                else {
                    return _bottomLeft!.remove(item, withOwnBounds: GQTPointQuadTreeChild.boundsBottomLeftChildQuadBounds(bounds))
                }
            }
        }
        
        if let index = _items!.indexOf({ $0 == item }) {
            _items!.removeAtIndex(index)
            return true
        }
        
        return false
    }
    
    func search(searchBounds: GQTBounds, ownBounds: GQTBounds, accumulator: NSMutableArray) {
        
        if let topRight = _topRight {
            
            let topRightBounds = GQTPointQuadTreeChild.boundsTopRightChildQuadBounds(ownBounds)
            let topLeftBounds = GQTPointQuadTreeChild.boundsTopLeftChildQuadBounds(ownBounds)
            let bottomRightBounds = GQTPointQuadTreeChild.boundsBottomRightChildQuadBounds(ownBounds)
            let bottomLeftBounds = GQTPointQuadTreeChild.boundsBottomLeftChildQuadBounds(ownBounds)
            
            if topRightBounds.intersectsWith(searchBounds) {
                topRight.search(searchBounds, ownBounds: topRightBounds, accumulator: accumulator)
            }
            
            if topLeftBounds.intersectsWith(searchBounds) {
                _topLeft?.search(searchBounds, ownBounds: topLeftBounds, accumulator: accumulator)
            }
            
            if bottomRightBounds.intersectsWith(searchBounds) {
                _bottomRight?.search(searchBounds, ownBounds: bottomRightBounds, accumulator: accumulator)
            }
            
            if bottomLeftBounds.intersectsWith(searchBounds) {
                _bottomLeft?.search(searchBounds, ownBounds: bottomLeftBounds, accumulator: accumulator)
            }
        }
        else {
            for item in _items! {
                let point = item.point
                
                if searchBounds.contains(point) {
                    accumulator.addObject(item)
                }
            }
            
        }
    }
}


// MARK - Static functions

extension GQTPointQuadTreeChild {
    
    class func boundsTopRightChildQuadBounds(parentBounds: GQTBounds) -> GQTBounds {
        let midPoint = parentBounds.midPoint
        
        let minX = midPoint.x
        let minY = midPoint.y
        let maxX = parentBounds.maxX
        let maxY = parentBounds.maxY
        
        return GQTBounds(minX: minX, minY: minY, maxX: maxX, maxY: maxY)
    }
    
    class func boundsTopLeftChildQuadBounds(parentBounds: GQTBounds) -> GQTBounds {
        let midPoint = parentBounds.midPoint
        
        let minX = parentBounds.minX
        let minY = midPoint.y
        let maxX = midPoint.x
        let maxY = parentBounds.maxY
        
        return GQTBounds(minX: minX, minY: minY, maxX: maxX, maxY: maxY)
    }
    
    class func boundsBottomRightChildQuadBounds(parentBounds: GQTBounds) -> GQTBounds {
        let midPoint = parentBounds.midPoint
        
        let minX = midPoint.x
        let minY = parentBounds.minY
        let maxX = parentBounds.maxX
        let maxY = midPoint.y
        
        return GQTBounds(minX: minX, minY: minY, maxX: maxX, maxY: maxY)
    }
    
    class func boundsBottomLeftChildQuadBounds(parentBounds: GQTBounds) -> GQTBounds {
        let midPoint = parentBounds.midPoint
        
        let minX = parentBounds.minX
        let minY = parentBounds.minY
        let maxX = midPoint.x
        let maxY = midPoint.y
        
        return GQTBounds(minX: minX, minY: minY, maxX: maxX, maxY: maxY)
    }
}

