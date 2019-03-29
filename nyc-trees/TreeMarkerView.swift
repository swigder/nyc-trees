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
            color = treeColors[tree.latinName] ?? defaultTreeColor
            let diameter = 5 + tree.diameter / 2
            frame = CGRect(x:0, y:0, width:diameter, height:diameter)
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        layer.sublayers?.removeAll()
        
        let halfLineWidth:CGFloat = 0.75
        
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: halfLineWidth, dy: halfLineWidth))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = color.cgColor.copy(alpha: 0.8)
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = halfLineWidth * 2
        layer.addSublayer(shapeLayer)
    }
}
