//
//  ArticlesTableTableViewController.swift
//  PersistentHistoryTrackingSample
//
//  Created by Nikolay Andonov on 7.01.18.
//  Copyright © 2018 mentormate. All rights reserved.
//

import UIKit
import CoreData

class ArticlesTableTableViewController: UITableViewController {
    
    private let cellReuseIdentifier = "reuseIdentifier"
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Article> = {
        let fetchedResultsController = CoreDataHandler.getArticlesFetchedResultsController()
        fetchedResultsController.delegate = self
        _fetchedResultsController = fetchedResultsController
        return fetchedResultsController
    }()
    
    private var _fetchedResultsController: NSFetchedResultsController<Article>?
    
    private var newArticleSaveAction: UIAlertAction?
    
    private var lastToken: NSPersistentHistoryToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.navigationItem.title = "Articles"
        
        loadPersistentData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(applicationWillEnterForeground(_:)),
                                               name:NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    private func loadPersistentData() {
        
        if _fetchedResultsController == nil && lastToken == nil {
            do {
                try fetchedResultsController.performFetch()
            } catch
                let error as NSError {
                    fatalError("Unresolved error \(error)")
            }
        }
        
        let fetchRequest = NSPersistentHistoryChangeRequest.fetchHistory(after: lastToken)
        let context = CoreDataManager.sharedInstance.viewContex
        do {
            let historyResult = try context.execute(fetchRequest) as! NSPersistentHistoryResult
            let history = (historyResult.result as! [NSPersistentHistoryTransaction])
            for transaction in history {
                context.mergeChanges(fromContextDidSave: transaction.objectIDNotification())
                self.lastToken = transaction.token
            }
        }
        catch let error as NSError {
            fatalError("Unresolved error \(error)")
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let articles = fetchedResultsController.fetchedObjects else { return 0 }
        return articles.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let article = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = article.name
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Actions
    
    @IBAction func addArticleButtonAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Create New Article", message: "", preferredStyle: .alert)
        
        newArticleSaveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            CoreDataHandler.insertArticleEntity(name: textField.text!)
            
        })
        newArticleSaveAction?.isEnabled = false
        alertController.addAction(newArticleSaveAction!)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "Article Name"
            textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Utilities
    
    @objc func textChanged(_ sender:UITextField) {
        if let text = sender.text {
            newArticleSaveAction?.isEnabled = text.count > 0
        }
    }
    
    @objc func applicationWillEnterForeground(_ notification: NSNotification) {
        loadPersistentData()
    }
    
}

// MARK: - NSFetchedResultsController

extension ArticlesTableTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            break;
        case .update:
            if let indexPath = indexPath, let _ = tableView.cellForRow(at: indexPath) {
                //Update functionality
            }
            break;
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            break;
        }
    }
}



