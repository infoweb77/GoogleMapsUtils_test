//
//  GQTPointQuadTreeItem.swift
//  GoogleMapsUtils_test
//
//  Created by alex on 03/10/16.
//  Copyright © 2016 alex. All rights reserved.
//

import Foundation

protocol GQTPointQuadTreeItem: class {
    var point: GQTPoint { get }
}

func == (lhs: GQTPointQuadTreeItem,rhs: GQTPointQuadTreeItem) -> Bool {
    return lhs == rhs
}
