//
//  ShareViewController.swift
//  SimpleTextShare
//
//  Created by Nikolay Andonov on 7.01.18.
//  Copyright © 2018 mentormate. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import CoreData

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }


    override func didSelectPost() {
        
        guard let text = textView.text else {return}
        CoreDataHandler.insertArticleEntity(name: text)
        
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
