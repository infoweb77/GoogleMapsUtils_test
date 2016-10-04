//
//  GCluster.swift
//  GoogleMapsUtils_test
//
//  Created by alex on 03/10/16.
//  Copyright © 2016 alex. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

protocol GCluster {
    var position: CLLocationCoordinate2D { get }
    var items: NSSet { get }
    //var marker: GMSMarker { set get }
}

