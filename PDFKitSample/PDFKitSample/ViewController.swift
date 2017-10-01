//
//  ViewController.swift
//  PDFKitSample
//
//  Created by Dobrinka Tabakova on 6/18/17.
//  Copyright © 2017 Dobrinka Tabakova. All rights reserved.
//

import UIKit
import PDFKit

class ViewController: UIViewController, PDFDocumentDelegate, UISearchBarDelegate {
    var pdfView: PDFView!
    var pdfDocument: PDFDocument!
    var selections: [PDFSelection] = []
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        
        self.pdfView = PDFView()
        self.pdfView.autoScales = true
        self.pdfView.frame = self.containerView.bounds
        self.containerView.addSubview(pdfView)
        
        if let documentUrl = Bundle.main.url(forResource: "pdf-sample", withExtension: "pdf"),
            let document = PDFDocument(url: documentUrl) {
            self.pdfDocument = document
            self.pdfDocument.delegate = self
            self.pdfView.document = document
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.selections.removeAll()
        self.pdfView.highlightedSelections = []
        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        
        if self.pdfDocument.isFinding {
            self.pdfDocument.cancelFindString()
        }
        if let searchText = searchBar.text {
            self.pdfDocument.beginFindString(searchText, withOptions: .caseInsensitive)
        }
    }

    func didMatchString(_ instance: PDFSelection) {
        instance.color = UIColor.yellow
        self.selections.append(instance)
    }
    
    func documentDidEndDocumentFind(_ notification: Notification) {
        self.pdfView.highlightedSelections = self.selections
    }
}

