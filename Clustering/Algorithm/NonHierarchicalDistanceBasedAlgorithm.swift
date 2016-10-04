//
//  NonHierarchicalDistanceBasedAlgorithm.swift
//  GoogleMapsUtils_test
//
//  Created by alex on 04/10/16.
//  Copyright © 2016 alex. All rights reserved.
//

import Foundation

class NonHierarchicalDistanceBasedAlgorithm: GClusterAlgorithm {
    
    var _items: [GQuadItem]
    
    private var _quadTree: GQTPointQuadTree
    private var _maxDistanceAtZoom: Int
    
    var items: Array<GQuadItem> {
        get {
            return _items
        }
    }
    
    init(maxDistanceAtZoom: Int = 50) {
        _items = [GQuadItem]()
        _maxDistanceAtZoom = maxDistanceAtZoom
        
        let bounds = GQTBounds(minX: 0, minY: 0, maxX: 1, maxY: 1)
        _quadTree = GQTPointQuadTree(bounds: bounds)
        
    }
    
    func addItem(item: GClusterItem) {
        let quadItem = GQuadItem(clusterItem: item)
        _items.append(quadItem)
        _quadTree.add(quadItem)
    }
    
    func removeItems() {
        _items.removeAll()
        _quadTree.clear()
    }
    
    func removeItemsNotInRectangle(bounds: GQTBounds) {
        var newItems = Array<GQuadItem>()
        _quadTree.clear()
        
        for item in _items {
            if bounds.contains(GQTPoint(x: item.position.latitude, y: item.position.longitude)) {
                newItems.append(item)
                _quadTree.add(item)
            }
        }
        
        _items = newItems
    }

    func getClusters(zoom: Double) -> NSSet {
        let discreteZoom = floor(zoom)
        let zoomSpecificSpan = Double(_maxDistanceAtZoom) / pow(2.0, discreteZoom) / 256.0
        
        let visitedCandidates = NSMutableSet()
        let results = NSMutableSet()
        var distanceToCluster = Dictionary<GQuadItem, Double>()
        var itemToCluster = Dictionary<String, GStaticCluster>()
        
        for candidate in items {
            if candidate.hidden || visitedCandidates.containsObject(candidate) {
                // Candidate is hidden or already part of another cluster.
                continue
            }
            
            let bounds = createBoundsFromSpan(candidate.point, span: zoomSpecificSpan)
            let clusterItems = _quadTree.search(bounds)
            
            if clusterItems.count == 1 {
                // Only the current marker is in range. Just add the single item to the results
                results.addObject(candidate)
                visitedCandidates.addObject(candidate)
                distanceToCluster[candidate] = 0.0
                
                continue
            }
            
            let cluster = GStaticCluster(coordinate: candidate.position, withMarker: candidate.marker)
            results.addObject(cluster)
            
            for clusterItem in clusterItems {
                guard let clusterItem = clusterItem as? GQuadItem where !clusterItem.hidden else {
                    continue
                }
                
                let distance = distanceSquared(clusterItem.point, b: candidate.point)
                
                if let existingDistance = distanceToCluster[clusterItem] {
                    
                    // Item already belongs to another cluster. Check if it's closer to this cluster
                    if existingDistance < distance {
                        continue
                    }
                    
                    // Move item to the closer cluster
                    if let oldCluster = itemToCluster[clusterItem.id] {
                        oldCluster.remove(clusterItem)
                    }
                }
                
                distanceToCluster[clusterItem] = distance
                cluster.add(clusterItem)
                itemToCluster[clusterItem.id] = cluster
            }
            
            visitedCandidates.addObjectsFromArray(clusterItems as [AnyObject])
        }
        
        return results
    }

    
    private func distanceSquared(a: GQTPoint, b: GQTPoint) -> Double {
        return (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y)
    }
    
    private func createBoundsFromSpan(point: GQTPoint, span: Double) -> GQTBounds {
        let halfSpan = span / 2
        
        return GQTBounds(minX: point.x - halfSpan, minY: point.y - halfSpan, maxX: point.x + halfSpan, maxY: point.y + halfSpan)
    }

}
