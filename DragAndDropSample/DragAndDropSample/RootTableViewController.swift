//
//  ViewController.swift
//  DragAndDropSample
//
//  Created by Nikolay Andonov on 17.12.17.
//  Copyright © 2017 mentormate. All rights reserved.
//

import UIKit

class RootTableViewController: UITableViewController {

    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.dropDelegate = self
        tableView.register(ContentImageTableViewCell.self, forCellReuseIdentifier: "ImageTableViewCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ContentImageTableViewCell
        cell.contentImageView.image = images[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonAction(_ sender: Any) {
        if let imagesViewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectionTableViewController") {
        navigationController?.pushViewController(imagesViewController, animated: true)
        }
    }
}

extension RootTableViewController: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        }
        else {
            let row = tableView.numberOfRows(inSection: 0)
            destinationIndexPath = IndexPath(row: row, section: 0)
        }
        
        coordinator.session.loadObjects(ofClass: UIImage.self) { images in
            guard let images = images as? [UIImage] else {
                return
            }
            var indexPaths = [IndexPath]()
            for (index, image) in images.enumerated() {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: 0)
                self.images.insert(image, at: destinationIndexPath.row)
                indexPaths.append(indexPath)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
}
