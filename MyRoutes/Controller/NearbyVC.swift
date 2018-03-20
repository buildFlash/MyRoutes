//
//  NearbyVC.swift
//  MyRoutes
//
//  Created by Aryan Sharma on 20/03/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit
import SVProgressHUD

class NearbyVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var nearbyList = [MapService.NearbySearchResult]()
    var location: String!
    fileprivate let cellId = "nearby"
    var place: Place!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var iconView: UIView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintAdjustmentMode = .normal
        self.navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchNearby()
        getWeather()
        
        let btn = UIBarButtonItem(title: "Navigate", style: .done, target: self, action: #selector(navigate))
        self.navigationItem.setRightBarButton(btn, animated: true)
    }
    
    @objc fileprivate func navigate() {
        let mapView = self.storyboard?.instantiateViewController(withIdentifier: "MapView") as? MapView
        mapView?.destinationLat = place.location.components(separatedBy: ",")[0]
        mapView?.destinationLong = place.location.components(separatedBy: ",")[1]
        mapView?.title = place.name
        self.navigationController?.pushViewController(mapView!, animated: true)
    }
    
    fileprivate func getWeather() {
        fetchWeatherInfo(location: place.location)
        title = place.name
    }
    
    fileprivate func fetchWeatherInfo(location: String) {
        WeatherService.shared.getWeatherDetails(location: location) { (result) in
            self.setIcon(icon: result.icon)
            let temp = Int(result.temperature)
            self.tempLabel.text = "\(temp)°F"
            self.summaryLabel.text = result.summary!
        }
    }
    
    fileprivate func setIcon(icon: String) {
        let iconView = SKYIconView(frame: CGRect(x: self.view.frame.width - 110, y: 85, width: 100, height: 100))
        iconView.setColor = UIColor.white
        iconView.backgroundColor = UIColor.clear
        switch icon {
        case "clear-night":
            iconView.setType = .clearNight
        case "clear-day":
            iconView.setType = .clearDay
        case "cloudy":
            iconView.setType = .cloudy
        case "fog":
            iconView.setType = .fog
        case "partly-cloudy-day":
            iconView.setType = .partlyCloudyDay
        case "partly-cloudy-night":
            iconView.setType = .partlyCloudyNight
        case "rain":
            iconView.setType = .rain
        case "sleet":
            iconView.setType = .sleet
        default:
            iconView.setType = .clearDay
        }
        self.view.addSubview(iconView)
    }
    
    fileprivate func fetchNearby() {
        SVProgressHUD.show()
        MapService.shared.fetchNearbyResults(location: place.location) { (result) in
            self.nearbyList = result
            SVProgressHUD.dismiss()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }


    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "NearbyCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NearbyCell
        let nearby = nearbyList[indexPath.row]
        cell.nearby = nearby
        return cell

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nearby = nearbyList[indexPath.row]
        let mapView = self.storyboard?.instantiateViewController(withIdentifier: "MapView") as? MapView
        mapView?.destinationLat = "\(nearby.geometry.location.lat!)"
        mapView?.destinationLong = "\(nearby.geometry.location.lng!)"
        mapView?.title = nearby.name
        self.navigationController?.pushViewController(mapView!, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
