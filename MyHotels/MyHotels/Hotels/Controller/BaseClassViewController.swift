//
//  BaseClassViewController.swift
//  MyHotels
//
//  Created by Bhanuteja on 20/07/21.
//

import UIKit

class BaseClassViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: Constants.Colors.background)
        self.navigationItem.title = Constants.errorTitle
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.barTintColor = UIColor(named: Constants.Colors.textColor)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.ok, style: .default) { action in
            completion?(action)
        }
        alertController.addAction(action)
        let parent = self.navigationController?.topViewController
        parent?.present(alertController, animated: false)
    }
}
