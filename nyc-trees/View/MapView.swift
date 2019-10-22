//
//  MapView.swift
//  nyc-trees-redux
//
//  Created by Suri Wigder on 10/20/19.
//  Copyright © 2019 Suri Wigder. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @ObservedObject var locationManager = LocationManager()

    var treeData: TreeData
    var coordinate: CLLocationCoordinate2D?
    let regionRadius: CLLocationDistance = 250
    
    let defaultCoordinate = CLLocationCoordinate2D(latitude:40.782222, longitude:-73.965278)
    
    func makeCoordinator() -> MapViewDelegate {
        MapViewDelegate(treeData: treeData)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.mapType = .standard
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        print("hi")
        let region = MKCoordinateRegion(center: coordinate ?? defaultCoordinate,
                                        latitudinalMeters: regionRadius,
                                        longitudinalMeters: regionRadius)
        view.setRegion(region, animated: true)
    }
}

class MapViewDelegate: NSObject, MKMapViewDelegate {
    var mapView: MKMapView?
    var treeIds = Set<Int>()
    var selectedAnnotation: SelectedTree?
    var treeData: TreeData
    
    init(treeData: TreeData) {
        self.treeData = treeData
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("fetch!")
        self.mapView = mapView
        fetchTrees(region: mapView.region, callback: treesWereFetched(trees:))
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        if annotation === selectedAnnotation {
            let reuseId = "selected"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            if view == nil {
                view = TreeMarkerSelectedView(annotation: annotation, reuseIdentifier: reuseId)
            } else {
                view?.annotation = annotation
            }
            return view
        } else {
            let reuseId = "others"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            if view == nil {
                view = TreeMarkerView(annotation: annotation, reuseIdentifier: reuseId)
            } else {
                view?.annotation = annotation
            }
            return view
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let treeMarker = view as? TreeMarkerView else { return }
        
        guard let tree = treeMarker.annotation as? Tree else { return }
        treeData.selectedTree = tree
        
        if selectedAnnotation != nil {
            mapView.removeAnnotation(selectedAnnotation!)
            selectedAnnotation?.coordinate = tree.coordinate
        } else {
            selectedAnnotation = SelectedTree(coordinate: tree.coordinate)
        }
        mapView.addAnnotation(selectedAnnotation!)
    }
    
    func treesWereFetched(trees: [Tree]) {
        let newTrees = trees.filter({ (tree: Tree) -> Bool in
            !treeIds.contains(tree.id)
        })
        print("Found \(trees.count) (\(newTrees.count) new) trees")
        if newTrees.isEmpty { return }
        newTrees.forEach { (tree: Tree) in treeIds.insert(tree.id) }
        DispatchQueue.main.async {
            self.mapView?.addAnnotations(newTrees)
        }
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let manager: CLLocationManager
    
    @Published var currentLocation: CLLocationCoordinate2D?

    init(manager: CLLocationManager = CLLocationManager()) {
        self.manager = manager
        super.init()
        self.startUpdating()
    }
    
    func startUpdating() {
        self.manager.delegate = self
        self.manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        let newLocation = locations.last?.coordinate
        if (newLocation != nil && !locationsEqual(a: newLocation, b: currentLocation)) {
            currentLocation = locations.last?.coordinate
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(coordinate: CLLocationCoordinate2D(
//        latitude:40.782222, longitude:-73.965278))
//    }
//}

func locationsEqual(a: CLLocationCoordinate2D?, b: CLLocationCoordinate2D?) -> Bool {
    return a?.latitude == b?.latitude && a?.longitude == b?.longitude
}
