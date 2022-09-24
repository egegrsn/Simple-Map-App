//
//  Extensions.swift
//  SimpleMapApp
//
//  Created by Ege Girsen on 24.09.2022.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
