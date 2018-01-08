//
//  SelectionTableViewController.swift
//  DragAndDropSample
//
//  Created by Nikolay Andonov on 17.12.17.
//  Copyright © 2017 mentormate. All rights reserved.
//

import UIKit

class SelectionTableViewController: UITableViewController {
    
    let images = [#imageLiteral(resourceName: "img1"),#imageLiteral(resourceName: "img2"),#imageLiteral(resourceName: "img3"),#imageLiteral(resourceName: "img4"),#imageLiteral(resourceName: "img5")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        tableView.register(ContentImageTableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! ContentImageTableViewCell
        cell.contentImageView.image = images[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.width
    }
}

extension SelectionTableViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return dragItems(forRow: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(forRow: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let parameters = UIDragPreviewParameters()
        let rect = CGRect(x: 0,
                          y: 0,
                          width: tableView.bounds.width,
                          height: tableView.bounds.width)
        parameters.visiblePath = UIBezierPath(roundedRect: rect,
                                              cornerRadius: 15)
        return parameters
    }
    
    private func dragItems(forRow row: Int) -> [UIDragItem] {
        let image = images[row]
        let itemProvider = NSItemProvider(object: image)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = image
        return [dragItem]
    }
    
}
