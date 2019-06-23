//
//  ViewController.swift
//  GPS
//
//  Created by Sophie Novak on 12/03/2018.
//  Copyright © 2018 Sophie Novak. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mymap: MKMapView!
    var loc=CLLocationManager()
    
    let destlat:CLLocationDegrees=51.623085
    let destlong:CLLocationDegrees = -3.948655
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let UserLocation:CLLocation=locations[0]
        let location:CLLocationCoordinate2D=UserLocation.coordinate
        directme(location: location,UserLocation: UserLocation)
    }
    func directme(location:CLLocationCoordinate2D,UserLocation:CLLocation){
        let destlocation:CLLocationCoordinate2D=CLLocationCoordinate2DMake(destlat, destlong)
        let request=MKDirectionsRequest()
        request.source=MKMapItem(placemark: MKPlacemark(coordinate:location))
        request.destination=MKMapItem(placemark: MKPlacemark(coordinate: destlocation))
        request.requestsAlternateRoutes=false
        request.transportType = .automobile
        
        mymap.delegate=self
        let directions=MKDirections(request:request)
        directions.calculate{[unowned self] response, error in guard let unwrappedResponse=response else{return}
            
            self.mymap.removeOverlay(self.mymap.overlays)
            for route in unwrappedResponse.routes{
                self.mymap.add(route.polyline)
                self.mymap.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top:40, left:40,bottom:40,right:40), animated: true)
            }
            
        }
        
        loc.stopUpdatingLocation()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mymap.mapType=MKMapType.standard
        mymap.isZoomEnabled=true
        
        let destlocation:CLLocationCoordinate2D=CLLocationCoordinate2DMake(destlat, destlong)
        let annotation=MKPointAnnotation()
        annotation.coordinate=destlocation
        annotation.title="UWTSD"
        
        mymap.addAnnotation(annotation)
        mymap.selectAnnotation(annotation, animated: true)
        
        loc.delegate=self as! CLLocationManagerDelegate
        loc.desiredAccuracy = kCLLocationAccuracyBest
        loc.requestWhenInUseAuthorization()
        loc.startUpdatingLocation()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

