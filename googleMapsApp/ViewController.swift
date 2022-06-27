//
//  ViewController.swift
//  googleMapsApp
//
//  Created by Mahmoud on 1/28/22.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    let coreManager =  CLLocationManager()
    let ceo : CLGeocoder = CLGeocoder()
    let marker = GMSMarker()
    override func viewDidLoad() {
        super.viewDidLoad()
        coreManager.delegate = self
        coreManager.requestWhenInUseAuthorization()  // the permission
        coreManager.startUpdatingLocation()      // to get the location
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return}
        let coordinate = location.coordinate
        let newLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        print(" Latitude\(coordinate.latitude), Longitude \(coordinate.longitude)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 1)
        mapView.camera = camera
        
        
        ceo.reverseGeocodeLocation(newLocation) { (placeMarks, error) in
            if error != nil {
                print("reverse geocode fail: \(error?.localizedDescription)")
            }
            let pm = placeMarks! as [CLPlacemark]
            if pm.count > 0 {
                self.marker.title = pm[0].name!
                self.marker.snippet = pm[0].country!
                
            }
        }
        
        marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        marker.map = mapView
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("the Error \(error)")
    }
}

