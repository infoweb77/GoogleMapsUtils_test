//
//  GCkusterAlgorithm.swift
//  GoogleMapsUtils_test
//
//  Created by alex on 04/10/16.
//  Copyright © 2016 alex. All rights reserved.
//

//import GoogleMaps
import UIKit

protocol GClusterAlgorithm {
    func addItem(item: GClusterItem)
    func removeItems()
    func removeItemsNotInRectangle(bounds: GQTBounds)

    func getClusters(zoom: Double) -> NSSet
}

