//
//  MapSearchVC.swift
//  BarHop
//
//  Created by John Landy on 5/6/19.
//  Copyright © 2019 Scott Macpherson. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// Map Search View Controller
class MapSearchVC: UIViewController {
    
    // Map view outlet
    @IBOutlet weak var mapView: MKMapView!
    // Button and label
    @IBOutlet weak var button: UIButton!
    
    let locationManager = CLLocationManager()
    let regionSpan: Double = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Make the view controller the mapView's delegate
        mapView.delegate = self as MKMapViewDelegate
        // Call check location services
        checkLocationServices()
        // Set button and label to invisible
        button.isHidden = true
    }
    
    // Function to add custom pins to the mapview
    private func addPins() {
        // For now, we will simply add a couple of pins manually, however, this
        // is where the query should be inserted to find bars within the view
        let bondBar = MKPointAnnotation()
        bondBar.title = "Bond Bar"
        bondBar.coordinate = CLLocationCoordinate2D(latitude: 37.7648, longitude: -122.4213)
        mapView.addAnnotation(bondBar)
        
        let theStud = MKPointAnnotation()
        theStud.title = "The Stud"
        theStud.coordinate = CLLocationCoordinate2D(latitude: 37.7728, longitude: -122.4101)
        mapView.addAnnotation(theStud)
    }
    
    // Function to set up the location manager
    func setUpLocationManager() {
        // Set our delegate (below extension stuff) so we can use the methods below
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // Function that centers the map on the user's location
    func centerViewOnUserLocation() {
        // Need if let and ? because location is an optional variable
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionSpan, longitudinalMeters: regionSpan)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // Function to check if location services are enabled on device
    func checkLocationServices() {
        
        if CLLocationManager.locationServicesEnabled() {
            // Set up our location manager
            setUpLocationManager()
            // Check location authorization
            checkLocationAuthorization()
        } else {
            // Here we need to show an alert letting the user know they have to turn these on
        }
    }
    
    // Function to check if location services are enabled for app
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // Set map to user location (checkbox in sidebar of MapView)
            // Center the view on the user's location
            centerViewOnUserLocation()
            // Update the location
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing how to turn on permissions
            break
        case .notDetermined:
            // Request permissiosn
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // User cannot change app status (e.g. due to parental controls)
            // Show alert instructing how to turn on permissions
            break
        case .authorizedAlways:
            // Don't really need this one
            break
        @unknown default:
            // Default catcher
            break
        }
    }
    
    // Handles button and label properties
    private func addPinInfo(name: String) {
        // Button
        let midPurple = UIColor(red: 85/255, green: 73/255, blue: 113/255, alpha: 1)
        button.isHidden = false
        button.frame = CGRect(x: 10, y: UIScreen.main.bounds.height*7/8, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height/12 - 10)
        button.setTitleColor(UIColor(white: 1, alpha: 1), for: .normal)
        button.setTitle("Go to \(name)", for: .normal)
        button.layer.cornerRadius = 8
        button.layer.backgroundColor = midPurple.cgColor
        button.titleLabel?.textColor = UIColor(white: 1, alpha: 1)
        mapView.addSubview(button)
    }
}

// Allow extension from CLLocationManagerDelegate
extension MapSearchVC: CLLocationManagerDelegate {
    // Handles location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Guard against no locations available: locations.last could be nil
        guard let location = locations.last else { return }
        // Create a center for the mapView
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        // Create a region based on the center and the desired regionSpan distance
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionSpan, longitudinalMeters: regionSpan)
        // Set the mapView to be on that region
        mapView.setRegion(region, animated: true)
        // Call addPins to actually see our pins
        addPins()
    }
    
    // Handles permission authorization changes, simply calls checkLocationAuthorization()
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapSearchVC: MKMapViewDelegate {
    // Function that runs when an annotation is clicked
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // Modally present a new view label and button to go to the correct screen
        addPinInfo(name: (view.annotation?.title)! ?? "Bar")
    }
}
