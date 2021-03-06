//
//  Park.swift
//  Park View
//
//  Created by Murilo Teixeira on 03/10/19.
//  Copyright © 2019 Ray Wenderlich. All rights reserved.
//

import UIKit
import MapKit

class Park {
    var name: String?
    var boundary: [CLLocationCoordinate2D] = []
    
    var midCoodinate = CLLocationCoordinate2D()
    var overlayTopLeftCoordinate = CLLocationCoordinate2D()
    var overlayTopRightCoordinate = CLLocationCoordinate2D()
    var overlayBottomLeftCoordinate = CLLocationCoordinate2D()
    var overlayBottomRightCoordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(overlayBottomLeftCoordinate.latitude, overlayTopRightCoordinate.longitude)
        }
    }
    
    var overlayBoundingMapRect: MKMapRect {
        get {
            let topLeft = MKMapPointForCoordinate(overlayTopLeftCoordinate)
            let topRight = MKMapPointForCoordinate(overlayTopRightCoordinate)
            let bottomLeft = MKMapPointForCoordinate(overlayBottomLeftCoordinate)
            
            return MKMapRectMake(
                topLeft.x,
                topLeft.y,
                fabs(topLeft.x - topRight.x),
                fabs(topLeft.y - bottomLeft.y))
        }
    }
    
    class func plist(_ plist: String) -> Any? {
        let filePath = Bundle.main.path(forResource: plist, ofType: "plist")!
        let data = FileManager.default.contents(atPath: filePath)!
        return try! PropertyListSerialization.propertyList(from: data, options: [], format: nil)
    }
    
    static func parseCorrd(dict: [String: Any], fieldName: String) -> CLLocationCoordinate2D {
        guard let coord = dict[fieldName] as? String else {
            return CLLocationCoordinate2D()
        }
        let point = CGPointFromString(coord)
        return CLLocationCoordinate2DMake(CLLocationDegrees(point.x), CLLocationDegrees(point.y))
    }
    
    init(filename: String) {
        guard let properties = Park.plist(filename) as? [String: Any],
            let boundaryPoints = properties["boundary"] as? [String]
            else { return }
        midCoodinate = Park.parseCorrd(dict: properties, fieldName: "midCoord")
        overlayTopLeftCoordinate = Park.parseCorrd(dict: properties, fieldName: "overlayTopLeftCoord")
        overlayTopRightCoordinate = Park.parseCorrd(dict: properties, fieldName: "overlayTopRightCoord")
        overlayBottomLeftCoordinate = Park.parseCorrd(dict: properties, fieldName: "overlayBottomLeftCoord")
        
        let cgPoints = boundaryPoints.map{ CGPointFromString($0)}
        boundary = cgPoints.map{ CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
    }
}
