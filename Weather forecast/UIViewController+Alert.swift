//
//  UIViewController+Alert.swift
//  Weather forecast
//
//  Created by islam metwally on 2/25/18.
//  Copyright © 2018 Islam Metwally. All rights reserved.
//

import Foundation
import  UIKit

extension UIViewController {
    
    func showError(message : String) {
        let alert = UIAlertController(title: "Error", message: message
            , preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.show(alert, sender: self)
    }
}
