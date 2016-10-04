//
//  GStaticCluster.swift
//  GoogleMapsUtils_test
//
//  Created by alex on 04/10/16.
//  Copyright © 2016 alex. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

class GStaticCluster: GCluster {
    
    private var _position: CLLocationCoordinate2D
    private var _items: Set<GQuadItem>
    
    var marker: GMSMarker
    
    var items: NSSet {
        return _items
    }
    
    var position: CLLocationCoordinate2D {
        if let quadItem = _items.first where _items.count == 1 {
            return quadItem.item.position
        }
        
        return _position
    }
    
    init(coordinate: CLLocationCoordinate2D, withMarker mark: GMSMarker) {
        _position = coordinate
        _items = Set<GQuadItem>()
        marker = mark
    }
    
    func add(item: GQuadItem) {
        _items.insert(item)
    }
    
    func remove(item: GQuadItem) {
        _items.remove(item)
    }
}

