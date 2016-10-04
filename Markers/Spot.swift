//
//  Spot.swift
//  GoogleMapsUtils_test
//
//  Created by alex on 03/10/16.
//  Copyright © 2016 alex. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

class Spot: NSObject, GClusterItem {
    var id: String
    var position: CLLocationCoordinate2D
    var marker: GMSMarker
    
    init(id: String, position: CLLocationCoordinate2D) {
        self.id = id
        self.position = position
        self.marker = GMSMarker()
    }
}