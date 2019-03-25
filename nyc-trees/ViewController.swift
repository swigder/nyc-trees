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

    let locationManager = CLLocationManager()
    
    let regionRadius: CLLocationDistance = 250
    let centralParkLocation = CLLocation(latitude:40.782222, longitude:-73.965278)

    var trees: [Tree] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapOnLocation(location: centralParkLocation)
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsUserLocation = true
        
        mapView.delegate = self
        
        mapView.register(TreeMarkerView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            centerMapOnLocation(location: centralParkLocation)
        }
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension ViewController: MKMapViewDelegate {

}

extension ViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocation = manager.location else { return }
        centerMapOnLocation(location: locValue)
        trees = fetchTrees(region: mapView.region)
        mapView.addAnnotations(trees)
    }
}
