//
//  MapView.swift
//  MyRoutes
//
//  Created by Aryan Sharma on 19/03/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit
import Polyline
import GoogleMaps

class MapView: UIViewController {

    @IBOutlet fileprivate weak var mapView: GMSMapView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var navigateBtn: UIButton!
    @IBOutlet weak var navigateBtnShadow: UIView!
    
    var destinationLat: String!
    var destinationLong: String!
    var bounds: GMSCoordinateBounds!
    var myLat: String!
    var myLong: String!
    
    lazy var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableNavigateBtn()
        setupMap()
        setupOtherComponents()
    }

    fileprivate func setupOtherComponents() {
        navigateBtn.layer.cornerRadius = navigateBtn.frame.height / 2
        navigateBtnShadow.layer.cornerRadius = navigateBtnShadow.frame.height / 2
        navigateBtnShadow.dropShadow()
    }

    
    fileprivate func setupMap() {
        mapView.delegate = self
        let camera = GMSCameraPosition.camera(withLatitude: (destinationLat as NSString).doubleValue, longitude: (destinationLong as NSString).doubleValue, zoom: 6.0)
        mapView.camera = camera
        showMarker(position: camera.target)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    fileprivate func disableNavigateBtn() {
        navigateBtn.isHidden = true
        navigateBtn.isEnabled = false
        navigateBtn.alpha = 0.5
    }
    
    fileprivate func enableNavigateBtn() {
        navigateBtn.isHidden = false
        navigateBtn.isEnabled = true
        navigateBtn.alpha = 1.0
    }

    func showMarker(position: CLLocationCoordinate2D){
        let marker = GMSMarker()
        marker.position = position
        marker.title = ""
        marker.snippet = ""
        marker.map = mapView
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            self.locationLabel.text = lines.joined(separator: "\n")
        }
    }

    @IBAction func navigateBtnPressed(_ sender: UIButton) {
        let urlToOpen = "https://www.google.com/maps/dir/?api=1&origin=\(myLat!),\(myLong!)&destination=\(destinationLat!),\(destinationLong!)"
        print(urlToOpen)
        guard let url = URL(string: urlToOpen) else {
            print("Can't cast url")
            return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        print(url)
    }
    
    @IBAction func recenterBtnPressed(_ sender: UIButton) {
        self.mapView.animate(with: GMSCameraUpdate.fit(self.bounds))
    }

}

extension MapView: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        myLat = String(format: "%f", location.coordinate.latitude)
        myLong = String(format:"%f", location.coordinate.longitude)
        
        let origin = myLat + "," + myLong
        let destination = (destinationLat!) + "," + (destinationLong!)

        MapService.shared.getDirections(origin: origin, destination: destination) { (route) in
            let polyline = Polyline(encodedPolyline: route.overview_polyline.points)
            let decodedCoordinates: [CLLocationCoordinate2D]? = polyline.coordinates
            self.drawPolyline(decodedCoordinates)
            self.updateBottomLabel(route)
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
        locationManager.stopUpdatingLocation()
    }
    
    fileprivate func updateBottomLabel(_ route: (MapService.Route)) {
        self.locationLabel.text = "It will take \(route.legs[0].duration.text) and \(route.legs[0].distance.text) to reach your destination."
        let labelHeight = self.locationLabel.intrinsicContentSize.height
        self.mapView.padding = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0,
                                            bottom: labelHeight, right: 0)
    }
    
    fileprivate func drawPolyline(_ decodedCoordinates: [CLLocationCoordinate2D]?) {
        let path = GMSMutablePath()
        for coordinate in decodedCoordinates! {
            path.add(coordinate)
        }
        let poly = GMSPolyline(path: path)
        poly.strokeWidth = 6
        poly.strokeColor = UIColor().HexToColor(hexString: "00BFFF")
        poly.map = self.mapView
        self.enableNavigateBtn()
        var bounds = GMSCoordinateBounds()
        for index in 1...path.count() {
            bounds = bounds.includingCoordinate(path.coordinate(at: index))
        }
        self.bounds = bounds
        self.mapView.animate(with: GMSCameraUpdate.fit(bounds))
    }
}


extension MapView: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//        reverseGeocodeCoordinate(position.target)
    }
}

