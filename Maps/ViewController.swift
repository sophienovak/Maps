//
//  ViewController.swift
//  Maps
//
//  Created by Sophie Novak on 26/02/2018.
//  Copyright © 2018 Sophie Novak. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
   
    @IBOutlet weak var map: MKMapView!
    
    func mapView(_ mapview: MKMapView, rendererFor overlay: MKOverlay) ->MKOverlayRenderer
    {
        if overlay is MKPolyline //set parameters of line required
        {
            let polylineRenderer = MKPolylineRenderer(overlay:overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 3
            return polylineRenderer
        }
        
        return overlay as! MKOverlayRenderer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.isZoomEnabled = true
        
        
        let lat:CLLocationDegrees = 51.624085
        let long:CLLocationDegrees = -3.948655
        
        let latzoomlevel:CLLocationDegrees = 0.005
        let longzoomlevel:CLLocationDegrees = 0.005
    
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long) //coordinate from lat and long values
        
        let thespan:MKCoordinateSpan = MKCoordinateSpanMake(latzoomlevel, longzoomlevel) //set final zoom level
        
        let reigon:MKCoordinateRegion = MKCoordinateRegionMake(location, thespan) //final map point and zoom level
        
        map.setRegion(reigon, animated: true)
        
        let annotation=MKPointAnnotation()
        annotation.coordinate=location
        annotation.title="UWTSD"
        annotation.subtitle="Mount Pleasant Campus"
        map.addAnnotation(annotation)
        
        let lat2:CLLocationDegrees = 51.6435923
        let long2:CLLocationDegrees = -3.9291268
        
        let location2:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat2, long2)
        
        let annotation2=MKPointAnnotation()
        annotation2.coordinate=location2
        annotation2.title="Morfa Retail Park"
        annotation2.subtitle="Shopping"
        map.addAnnotation(annotation2)
        
        var points:[CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        points.append(annotation.coordinate)//Pin 1
        points.append(annotation2.coordinate)//Pin 2
        map.delegate=self
        //let polyline=MKPolyline(coordinates:&points, count:points.count)
        //map.add(polyline)    adds straight line
        
        let request = MKDirectionsRequest()
        request.source=MKMapItem(placemark:MKPlacemark(coordinate:location))
        request.destination=MKMapItem(placemark:MKPlacemark(coordinate:location2))
        
        request.requestsAlternateRoutes=false
        request.transportType = .automobile
        
        let directions=MKDirections(request:request)
        directions.calculate{[unowned self] response,error in guard let unwrappedResponse=response else {return}
            for route in unwrappedResponse.routes{
                self.map.add(route.polyline)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

