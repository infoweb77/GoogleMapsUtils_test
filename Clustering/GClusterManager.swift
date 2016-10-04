//
//  GClusterManager.swift
//  GoogleMapsUtils_test
//
//  Created by alex on 04/10/16.
//  Copyright © 2016 alex. All rights reserved.
//

import GoogleMaps
import UIKit

protocol GClusterManagerDelegate {
    func clusterManager(clusterManager: GClusterManager, didTapCluster cluster: GCluster)
}


final class GClusterManager: NSObject {
    
    private var _previousCameraPosition: GMSCameraPosition?
    
    var delegate: GClusterManagerDelegate?
    weak var mapDelegate: GMSMapViewDelegate?
    
    var items: NSMutableArray?
    
    var mapView: GMSMapView {
        didSet {
            _previousCameraPosition = nil
        }
    }
    
    var clusterAlgorithm: GClusterAlgorithm {
        didSet {
            _previousCameraPosition = nil
        }
    }
    
    var clusterRenderer: GClusterRenderer {
        didSet {
            _previousCameraPosition = nil
        }
    }
    
    init(mapView: GMSMapView, algorithm: GClusterAlgorithm, renderer: GClusterRenderer) {
        self.mapView = mapView
        self.clusterAlgorithm = algorithm
        self.clusterRenderer = renderer
    }
    
    func addItem(item: GClusterItem) {
        clusterAlgorithm.addItem(item)
    }
    
    func removeItems() {
        clusterAlgorithm.removeItems()
    }
    
    func removeItemsNotInRectangle(bounds: GQTBounds) {
        clusterAlgorithm.removeItemsNotInRectangle(bounds)
    }
    
    func cluster() {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        let zoom = Double(mapView.camera.zoom)
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) { [unowned self] in
            let clusters = self.clusterAlgorithm.getClusters(zoom)
            
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.clusterRenderer.clustersChanged(clusters)
            }
        }
    }
    
    func setDelegate(delegate: GClusterManagerDelegate, mapDelegate mapDel: GMSMapViewDelegate) {
        self.delegate = delegate
        mapView.delegate = self
        self.mapDelegate = mapDel
    }
}

extension GClusterManager: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
        mapDelegate?.mapView?(mapView, willMove: gesture)
    }
    
    func mapView(mapView: GMSMapView, didChangeCameraPosition position: GMSCameraPosition) {
        mapDelegate?.mapView?(mapView, didChangeCameraPosition: position)
    }
    
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        assert(mapView == self.mapView)
        
        // Don't recompute clusters if the map has just been panned/tilted/rotated.
        let pos = mapView.camera
        
        if _previousCameraPosition?.target.latitude == pos.target.latitude && _previousCameraPosition?.target.longitude == pos.target.longitude {
            if mapDelegate != nil {
                mapDelegate?.mapView?(mapView, idleAtCameraPosition: position)
                return
            }
        }
        
        _previousCameraPosition = mapView.camera
        
        self.cluster()
        
        mapDelegate?.mapView?(mapView, idleAtCameraPosition: position)
    }
    
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        mapDelegate?.mapView?(mapView, didTapAtCoordinate: coordinate)
    }
    
    func mapView(mapView: GMSMapView, didCloseInfoWindowOfMarker marker: GMSMarker) {
        mapDelegate?.mapView?(mapView, didCloseInfoWindowOfMarker: marker)
    }
    
    func mapView(mapView: GMSMapView, didBeginDraggingMarker marker: GMSMarker) {
        mapDelegate?.mapView?(mapView, didBeginDraggingMarker: marker)
    }
    
    func mapView(mapView: GMSMapView, didLongPressInfoWindowOfMarker marker: GMSMarker) {
        mapDelegate?.mapView?(mapView, didLongPressInfoWindowOfMarker: marker)
    }
    
    func mapView(mapView: GMSMapView, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
        mapDelegate?.mapView?(mapView, didLongPressAtCoordinate: coordinate)
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        if let result = mapDelegate?.mapView?(mapView, didTapMarker: marker) {
            return result
        }
        
        return false
    }
    
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        mapDelegate?.mapView?(mapView, didTapInfoWindowOfMarker: marker)
    }
    
    func mapView(mapView: GMSMapView, didTapOverlay overlay: GMSOverlay) {
        mapDelegate?.mapView?(mapView, didTapOverlay: overlay)
    }
    
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if let view = mapDelegate?.mapView?(mapView, markerInfoWindow: marker) {
            return view
        }
        
        return nil
    }
    
    func mapView(mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        if let view = mapDelegate?.mapView?(mapView, markerInfoContents: marker) {
            return view
        }
        
        return nil
    }
    
    func mapView(mapView: GMSMapView, didEndDraggingMarker marker: GMSMarker) {
        mapDelegate?.mapView?(mapView, didEndDraggingMarker: marker)
    }
    
    func mapView(mapView: GMSMapView, didDragMarker marker: GMSMarker) {
        mapDelegate?.mapView?(mapView, didDragMarker: marker)
    }
}


