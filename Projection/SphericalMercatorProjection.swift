//
//  SphericalMercatorProjection.swift
//  GoogleMapsUtils_test
//
//  Created by alex on 03/10/16.
//  Copyright © 2016 alex. All rights reserved.
//

import CoreLocation

class SphericalMercatorProjection {
    private let _worldWidth: Double
    
    init(worldWidth: Double) {
        _worldWidth = worldWidth
    }
    
    convenience init() {
        self.init(worldWidth: 1)
    }
    
    func pointToCoordinate(point: GQTPoint) -> CLLocationCoordinate2D {
        let x = point.x / _worldWidth - 0.5
        let lng = x * 360
        
        let y = 0.5 - (point.y / _worldWidth)
        let lat = 90 - ((atan(exp(-y * 2 * M_PI)) * 2) * (180.0 / M_PI))
        
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    
    func coordinateToPoint(coordinate: CLLocationCoordinate2D) -> GQTPoint {
        let x = coordinate.longitude / 360 + 0.5
        let siny = sin(coordinate.latitude / 180.0 * M_PI)
        let y = 0.5 * log((1 + siny) / (1 - siny)) / -(2 * M_PI) + 0.5
        
        return GQTPoint(x: x * _worldWidth, y: y * _worldWidth)
    }
}

