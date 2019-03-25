//
//  DataRequester.swift
//  nyc-trees
//
//  Created by Suri Wigder on 3/24/19.
//  Copyright © 2019 Suri Wigder. All rights reserved.
//

import Foundation
import MapKit

let url = URL(string:"https://data.cityofnewyork.us/resource/uvpi-gqnh.json")!

func fetchTrees(region: MKCoordinateRegion) -> [Tree] {
    let semaphore = DispatchSemaphore(value: 0)
    
    var result: [Tree] = []
    
    let latitudeMin = region.center.latitude - region.span.latitudeDelta/2
    let latitudeMax = region.center.latitude + region.span.latitudeDelta/2
    let longitudeMin = region.center.longitude - region.span.longitudeDelta/2
    let longitudeMax = region.center.longitude + region.span.longitudeDelta/2
    
    let queryItems: [URLQueryItem]? = [
        URLQueryItem(name: "$where", value: "latitude between \(latitudeMin) and \(latitudeMax) and longitude between \(longitudeMin) and \(longitudeMax)"),
    ]

    let locationUrlComponents = NSURLComponents(string: url.absoluteString)
    locationUrlComponents!.queryItems = queryItems

    print(locationUrlComponents!.url!)
    
    let task = URLSession.shared.dataTask(with: locationUrlComponents!.url!) {(data, response, error) in
        do {
            result = try JSONDecoder().decode([Tree].self, from: data!)
        } catch {
            print("json error: \(error)")
        }
        semaphore.signal()
    }
    
    task.resume()
    semaphore.wait()
    return result
}
