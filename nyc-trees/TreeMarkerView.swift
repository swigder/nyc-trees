//
//  TreeMarkerView.swift
//  nyc-trees
//
//  Created by Suri Wigder on 3/24/19.
//  Copyright © 2019 Suri Wigder. All rights reserved.
//

import Foundation

import MapKit

class TreeMarkerView: MKAnnotationView {
    
    var color: UIColor = UIColor.clear
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let tree = newValue as? Tree else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            color = tree.markerTintColor
            let diameter = max(5, tree.diameter)
            frame = CGRect(x:0, y:0, width:diameter, height:diameter)
        }
    }
    
    override func draw(_ rect: CGRect) {
        let halfLineWidth:CGFloat = 0.75
        
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: halfLineWidth, dy: halfLineWidth))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = halfLineWidth * 2
        layer.addSublayer(shapeLayer)
    }
}
