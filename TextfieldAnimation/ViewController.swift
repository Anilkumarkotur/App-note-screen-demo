//
//  ViewController.swift
//  TextfieldAnimation
//
//  Created by Anilkumar kotur on 01/06/20.
//  Copyright © 2020 Swifter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var textFieldFullHeight:CGFloat = {
     self.view.frame.size.height - 100
    }()
    
    var textFieldHalfHeight:CGFloat = 200
    
    let textViewToUse: UITextView = {
        let textview = UITextView(frame: CGRect.zero)
        textview.font = UIFont.systemFont(ofSize: 20)
        textview.backgroundColor = .darkGray
        return textview
    }()
    
    var heightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleNewNote))
        
        view.addSubview(textViewToUse)
        textViewToUse.translatesAutoresizingMaskIntoConstraints = false
        textViewToUse.isEditable = true
        
        heightConstraint = NSLayoutConstraint(item: textViewToUse,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1,
                                              constant: textFieldFullHeight)
        
        NSLayoutConstraint.activate([
            textViewToUse.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            textViewToUse.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            textViewToUse.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
        ])
        
        textViewToUse.addConstraint(heightConstraint!)
                
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleNewNote(){
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }
        let keybardFrame = keyboardSize.cgRectValue
        textFieldHalfHeight = self.view.frame.size.height - keybardFrame.height - 30
        UIView.animate(withDuration: 0.2,
                       delay: 0.2,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {
                        self.heightConstraint?.constant = self.textFieldHalfHeight
                        self.view.layoutIfNeeded()
        },completion: nil)
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.2, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.heightConstraint?.constant = self.textFieldFullHeight
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

