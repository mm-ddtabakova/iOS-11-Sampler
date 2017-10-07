//
//  ViewController.swift
//  CoreNFCSample
//
//  Created by Dobrinka Tabakova on 10/7/17.
//  Copyright © 2017 Dobrinka Tabakova. All rights reserved.
//

import UIKit
import CoreNFC

class ViewController: UIViewController, NFCNDEFReaderSessionDelegate {

    @IBOutlet weak var infoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func scanButtonTapped(_ sender: Any) {
        let nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession.alertMessage = "Hold iPhone near NFC tag."
        nfcSession.begin()
    }
    
    public func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("Your Session was invalidated - ", error.localizedDescription)
    }
    
    public func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        var result = ""
        for record in messages[0].records {
            result += "Type name format: \(record.typeNameFormat)\n\n"
            result += "Type: " + String.init(data: record.type, encoding: .utf8)! + "\n\n"
            result += "Identifier: " + String.init(data: record.identifier, encoding: .utf8)! + "\n\n"
            result += "Payload: " + String.init(data: record.payload, encoding: .utf8)!
        }
        DispatchQueue.main.async {
            self.infoTextView.text = result
        }
    }
}

