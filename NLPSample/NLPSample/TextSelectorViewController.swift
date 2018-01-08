//
//  TextSelectorViewController.swift
//  NLPSample
//
//  Created by Nikolay Andonov on 4.01.18.
//  Copyright © 2018 mentormate. All rights reserved.
//

import UIKit

class TextSelectorViewController: UIViewController {
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var breakdownTextView: UITextView!
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
    @IBAction func breakdownButtonAction(_ sender: Any) {
        
        languageLabel.text = ""
        breakdownTextView.text = ""
        
        languageLabel.text = "Dominant language: \(getTextLanguage() ?? "Undefined")"
        requestTextBreakDown { (text) in
            breakdownTextView.text = breakdownTextView.text + text + "\n"
        }
    }
    
}

//MARK: - NSLinguistic

extension TextSelectorViewController {
    
    private func getTextLanguage() -> String? {
        
        let tagger = NSLinguisticTagger(tagSchemes: [.language], options: 0)
        tagger.string = textField.text
        guard let language = tagger.dominantLanguage else {
            print("can't get domainant language")
            return nil;
        }
        
        print(language)
        return language
    }
    
    private func requestTextBreakDown(completition: (String) -> ()) {
        
        let tagger = NSLinguisticTagger(tagSchemes: [.lexicalClass], options: 0)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
        
        guard let text = textField.text else {
            print("can't provide a breakdown for the text")
            return
        }
        tagger.string = text
        
        let range = NSRange(location: 0, length: text.utf16.count)
        tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, stop in
            let word = (text as NSString).substring(with: tokenRange)
            let breakdownText = "\(tag!.rawValue): \(word)"
            completition(breakdownText)
        }
    }
    
}

//MARK: - Utilities

extension TextSelectorViewController {
    
    private func setupUI() {
        
        languageLabel.text = ""
        breakdownTextView.text = ""
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
}

