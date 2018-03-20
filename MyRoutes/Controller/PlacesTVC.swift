//
//  PlacesTVC.swift
//  MyRoutes
//
//  Created by Aryan Sharma on 19/03/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit
import SVProgressHUD

class PlacesTVC: UITableViewController {
    
    var placesList = [Place]()
    fileprivate let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Routes"
        getPlaces()
        setupTableView()
    }
    
    fileprivate func getPlaces() {
        SVProgressHUD.show()
        APIService.shared.fetchPlaces { (list) in
            self.placesList = list
            SVProgressHUD.dismiss()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "PlaceCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return placesList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PlaceCell
        let place = placesList[indexPath.row]
        cell.place = place
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 154
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = placesList[indexPath.row]
        print(place.name + " located at " + place.location)
        
        let nearbyVC = self.storyboard?.instantiateViewController(withIdentifier: "NearbyVC") as? NearbyVC
        nearbyVC?.place = place
        self.navigationController?.pushViewController(nearbyVC!, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
