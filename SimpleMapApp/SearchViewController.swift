//
//  SearchViewController.swift
//  SimpleMapApp
//
//  Created by Ege Girsen on 23.09.2022.
//

import UIKit

protocol searchProtocol{
    func sendSearchInput(searchStr: String)
}

class SearchViewController: UIViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    private var temp = String()
    var delegate: searchProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Take the value from the textfield and search the place.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text != ""{
            self.delegate?.sendSearchInput(searchStr: textField.text!)
        }else{
            self.showAlert(message: "You need to type something to search. (e.g Cafe, Hotels, etc.)", title: "Sorry")
        }
       
        return true
    }

}
