//
//  EditContactTableViewController.swift
//  Contacts
//
//  Created by Levi Linchenko on 28/09/2018.
//  Copyright © 2018 Levi Linchenko. All rights reserved.
//

import UIKit

class EditContactTableViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if contact != nil {
            nameTextField.text = contact?.name
            if let contactPhoneNumber = contact?.phoneNumber {
                phoneNumberTextField.text = String(contactPhoneNumber)
            }
            emailTextField.text = contact?.email
        }
        
    }
    
    var contact: Contact?
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    
    
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        guard let name = nameTextField.text,
            let phoneNumber = phoneNumberTextField.text,
            let email = emailTextField.text else {return}
        guard name != "" else {
            self.presentAlertController()
            return
        }
        if phoneNumber != "" {
            guard Int(phoneNumber) != nil else {
                presentAlertController()
                return
            }
        }
        
        if contact != nil{
            guard let contact = contact else {return}
            ContactController.shared.updateContact(contact: contact, name: name, phoneNumber: phoneNumber, email: email) { (success) in
            }
            
        } else {
            
            ContactController.shared.createContact(name: name, phoneNumber: phoneNumber, email: email) { (success) in
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
