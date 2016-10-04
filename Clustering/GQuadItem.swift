//
//  GQuadItem.swift
//  GoogleMapsUtils_test
//
//  Created by alex on 03/10/16.
//  Copyright © 2016 alex. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

final class GQuadItem: NSObject, GCluster, GQTPointQuadTreeItem, NSCopying {
    private var _item: GClusterItem
    private var _point: GQTPoint
    private var _position: CLLocationCoordinate2D
    
    var marker: GMSMarker
    var hidden: Bool = false
    
    var id: String {
        return _item.id
    }
    
    var item: GClusterItem {
        return _item
    }
    
    var items: NSSet {
        return NSSet(object: _item)
    }
    
    var position: CLLocationCoordinate2D {
        return _position
    }
    
    var point: GQTPoint {
        return _point
    }
    
    
    
    init(clusterItem: GClusterItem) {
        let projection = SphericalMercatorProjection(worldWidth: 1.0)
        
        _position = clusterItem.position
        _point = projection.coordinateToPoint(_position)
        _item = clusterItem
        
        marker = clusterItem.marker
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let newGQuadItem = GQuadItem(clusterItem: _item)
        newGQuadItem._point = _point
        newGQuadItem._item = _item
        newGQuadItem._position = _position
        return newGQuadItem
    }
    
    override func isEqual(other: AnyObject?) -> Bool {
        if self === other {
            return true
        }
        
        guard let other = other as? GQuadItem else {
            return false
        }
        
        return self._item.isEqual(other._item)
    }
    
    override var hash: Int {
        return _item.hash
    }
}