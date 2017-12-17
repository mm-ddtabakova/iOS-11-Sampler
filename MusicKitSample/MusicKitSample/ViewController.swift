//
//  ViewController.swift
//  MusicKitSample
//
//  Created by Dobrinka Tabakova on 12/17/17.
//  Copyright © 2017 Dobrinka Tabakova. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var songs: [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        let song = songs[indexPath.row]
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.artistName
        
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else {
            return
        }
        self.songs = []
        self.tableView.reloadData()
        activityIndicator?.startAnimating()
        
        DataManager.sharedInstance.getSearchResults(searchTerm: searchTerm, completion: {(data) in
                DispatchQueue.main.async {
                    if let result = data {
                        self.songs = result
                        self.tableView.reloadData()
                    } else {
                        //error
                    }
                    self.activityIndicator?.stopAnimating()
                }
        })
    }
}

