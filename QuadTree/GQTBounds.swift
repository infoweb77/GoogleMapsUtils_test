//
//  GQTBounds.swift
//  GoogleMapsUtils_test
//
//  Created by alex on 03/10/16.
//  Copyright © 2016 alex. All rights reserved.
//

struct GQTBounds {
    var minX: Double
    var minY: Double
    var maxX: Double
    var maxY: Double
    
    var midPoint: GQTPoint {
        return GQTPoint(x: (minX + maxX) / 2, y: (minY + maxY) / 2)
    }
    
    func intersectsWith(bounds: GQTBounds) -> Bool {
        return(!(self.maxY < bounds.minY || bounds.maxY < self.minY) && !(self.maxX < bounds.minX || bounds.maxX < self.minX))
    }
    
    func contains(point: GQTPoint) -> Bool {
        let containsX = minX <= point.x && point.x <= maxX
        let containsY = minY <= point.y && point.y <= maxY
        
        return containsX && containsY
    }
}

