//
//  ViewController.swift
//  nyc-trees
//
//  Created by Suri Wigder on 3/24/19.
//  Copyright © 2019 Suri Wigder. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var commonNameLabel: UILabel!

    let locationManager = CLLocationManager()
    
    let regionRadius: CLLocationDistance = 250
    let centralParkLocation = CLLocation(latitude:40.782222, longitude:-73.965278)

    var treeIds = Set<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapOnLocation(location: centralParkLocation)
        mapView.mapType = .standard
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        
        let trackingButton = MKUserTrackingButton(mapView: mapView)
        trackingButton.frame = CGRect(origin: CGPoint(x:5, y: 25), size: CGSize(width: 35, height: 35))
        mapView.addSubview(trackingButton)

        mapView.delegate = self
        
        mapView.register(TreeMarkerView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
                
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            if locationManager.location != nil {
                centerMapOnLocation(location: locationManager.location!)
            }
        } else {
            centerMapOnLocation(location: centralParkLocation)
            updateTrees()
        }
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func updateTrees() {
        fetchTrees(region: mapView.region, callback: treesWereFetched(trees:))
    }
    
    func treesWereFetched(trees: [Tree]) {
        let newTrees = trees.filter({ (tree: Tree) -> Bool in
            !treeIds.contains(tree.id)
        })
        print("Found \(trees.count) (\(newTrees.count) new) trees")
        if newTrees.isEmpty { return }
        newTrees.forEach { (tree: Tree) in treeIds.insert(tree.id) }
        DispatchQueue.main.async {
            self.mapView.addAnnotations(newTrees)
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        updateTrees()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let treeMarker = view as? TreeMarkerView else { return }

        commonNameLabel.text = view.annotation?.title ?? ""
    }
}

extension ViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocation = manager.location else { return }
        centerMapOnLocation(location: locValue)
        updateTrees()
        locationManager.delegate = nil
    }
}
