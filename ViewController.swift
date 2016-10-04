//
//  ViewController.swift
//  GoogleMapsUtils_test
//
//  Created by alex on 03/10/16.
//  Copyright © 2016 alex. All rights reserved.
//

import UIKit
import GoogleMaps

let kClusterItemCount = 15000
let kCameraLatitude = 55.9825
let kCameraLongitude = 37.1814

class ViewController: UIViewController, GClusterManagerDelegate, GMSMapViewDelegate {
    
    private var mapView: GMSMapView!
    private var clusterManager: GClusterManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Google Maps Utils Test"
        
        let camera = GMSCameraPosition.cameraWithLatitude(kCameraLatitude, longitude: kCameraLongitude, zoom: 10)
        mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        self.view = mapView
        
        let algorithm = NonHierarchicalDistanceBasedAlgorithm()
        let renderer = GDefaultClusterRenderer(mapView: mapView)
        clusterManager = GClusterManager(mapView: mapView, algorithm: algorithm, renderer: renderer)
        
        generateClusterItems()
        
        clusterManager.cluster()
        
        // Register self to listen to both GClusterManagerDelegate and GMSMapViewDelegate events.
        clusterManager.setDelegate(self, mapDelegate: self)
    }
    
    // MARK: - GClusterManagerDelegate
    
    func clusterManager(clusterManager: GClusterManager, didTapCluster cluster: GCluster) {
        let newCamera = GMSCameraPosition.cameraWithTarget(cluster.position, zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.moveCamera(update)
    }
    
    // MARK: - GMUMapViewDelegate
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        if let spot = marker.userData as? Spot {
            NSLog("Did tap marker for cluster item \(spot.id)")
        } else {
            NSLog("Did tap a normal marker")
        }
        return false
    }

    // MARK: - Private
    
    /// Randomly generates cluster items within some extent of the camera and adds them to the
    /// cluster manager.
    private func generateClusterItems() {
        let extent = 0.2
        for index in 1...kClusterItemCount {
            let lat = kCameraLatitude + extent * randomScale()
            let lng = kCameraLongitude + extent * randomScale()
            
            let pos = CLLocationCoordinate2DMake(lat, lng)
            let id = "Item \(index)"
            
            let item = Spot(id: id, position: pos)
            clusterManager.addItem(item)
        }
    }
    
    /// Returns a random value between -1.0 and 1.0.
    private func randomScale() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

