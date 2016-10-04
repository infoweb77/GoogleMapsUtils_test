//
//  GDefaultClusterRenderer.swift
//  GoogleMapsUtils_test
//
//  Created by alex on 04/10/16.
//  Copyright © 2016 alex. All rights reserved.
//

import Foundation
import GoogleMaps

class GDefaultClusterRenderer: GClusterRenderer {
    
    private var _map: GMSMapView
    private var _markerCache: [GMSMarker]
    
    init(mapView: GMSMapView) {
        _map = mapView
        _markerCache = [GMSMarker]()
    }
    
    func clustersChanged(clusters: NSSet) {
        clearCache()
        
        for cluster in clusters {
            guard let cluster = cluster as? GCluster else {
                continue
            }
            
            let marker = GMSMarker()
            _markerCache.append(marker)
            
            let count = cluster.items.count
            
            if count > 1 {
                marker.iconView = GDefaultClusterMarkerIconView(count: count)
            }
            else if count == 1 {
                marker.iconView = UIImageView(image: GMSMarker.markerImageWithColor(UIColor(red: 0.0, green: 0.3921, blue: 1.0, alpha: 1.0)))
            }
            
            marker.position = cluster.position
            marker.tracksViewChanges = false
            marker.map = _map
        }

    }
    
    private func clearCache() {
        for marker in _markerCache {
            marker.map = nil
        }
        _markerCache.removeAll()
    }
}
