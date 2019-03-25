//
//  TreeData.swift
//  nyc-trees
//
//  Created by Suri Wigder on 3/24/19.
//  Copyright © 2019 Suri Wigder. All rights reserved.
//

import Foundation
import MapKit

class Tree: NSObject, MKAnnotation, Decodable {
    let address: String
    let commonName: String
    let latinName: String
    let diameter: Int
    let latitude: Double
    let longitude: Double
    
    enum JsonKeys: String, CodingKey {
        case address = "address"
        case commonName = "spc_common"
        case latinName = "spc_latin"
        case liveTreeDiameter = "tree_dbh"
        case stumpDiameter = "stump_diam"
        case latitude = "latitude"
        case longitude = "longitude"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: JsonKeys.self)

        self.address = try container.decode(String.self, forKey: .address)
        self.commonName = (try? container.decode(String.self, forKey: .commonName)) ?? ""
        self.latinName = (try? container.decode(String.self, forKey: .latinName)) ?? ""
        self.diameter = try Int(container.decode(String.self, forKey: .liveTreeDiameter))!
        self.latitude = try Double(container.decode(String.self, forKey: .latitude))!
        self.longitude = try Double(container.decode(String.self, forKey: .longitude))!
    }
    
    var title: String? {
        return commonName
    }
    
    var subtitle: String? {
        return latinName
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var markerTintColor: UIColor  {
        switch latinName {
        case "Platanus x acerifolia":
            return .red
        case "Ginkgo biloba":
            return .cyan
        case "Gleditsia triacanthos var. inermis":
            return .blue
        case "Tilia americana":
            return .purple
        default:
            return .green
        }
    }

}
