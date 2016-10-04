//
//  GClusterItem.swift
//  GoogleMapsUtils_test
//
//  Created by alex on 03/10/16.
//  Copyright © 2016 alex. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

protocol GClusterItem: NSObjectProtocol {
    var id: String { get }
    var position: CLLocationCoordinate2D { get }
    var marker: GMSMarker { set get }
}
