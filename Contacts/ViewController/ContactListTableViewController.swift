//
//  ContactListTableViewController.swift
//  Contacts
//
//  Created by Levi Linchenko on 28/09/2018.
//  Copyright © 2018 Levi Linchenko. All rights reserved.
//

import UIKit

class ContactListTableViewController: UITableViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: ContactController.shared.notificationName, object: nil)
        ContactController.shared.fetchAllContacts()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateViews()
    }
    
    @objc func updateViews(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return ContactController.shared.contacts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactsCell", for: indexPath)
        
        let contact = ContactController.shared.contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.email
        
        return cell
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contact = ContactController.shared.contacts[indexPath.row]
            ContactController.shared.deleteContact(contact: contact, indexPath: indexPath.row) { (success) in
                
            }
        }   
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditContactVC"{
            let destinationVC = segue.destination as? EditContactTableViewController
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let contact = ContactController.shared.contacts[indexPath.row]
            destinationVC?.contact = contact
            
        }
    }
    
    
}
