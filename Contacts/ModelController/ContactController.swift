//
//  ContactController.swift
//  Contacts
//
//  Created by Levi Linchenko on 28/09/2018.
//  Copyright © 2018 Levi Linchenko. All rights reserved.
//

import UIKit
import CloudKit

class ContactController {
    
    static let shared = ContactController()
    private init () {}
    
    var contacts: [Contact] = []{
        didSet{
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }
    let notificationName = Notification.Name("ContactsUpdated")
    var privateDB = CKContainer.default().privateCloudDatabase
    
    func createContact(name: String, phoneNumber: String, email: String, completion: @escaping (_ success: Bool)->Void){
        let contact = Contact(name: name, phoneNumber: phoneNumber, email: email)
        guard let record = CKRecord(contact: contact) else {print("not creating record, \(#file), \(#function)");return}
        privateDB.save(record) { (record, error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error.localizedDescription)💩💩")
                return
            }
            self.contacts.append(contact)

        }
    }
    
    func updateContact(contact: Contact, name: String?, phoneNumber: String?, email: String?, completion: @escaping (_ success: Bool)->Void) {
        
        let ckmodifier = CKModifyRecordsOperation()
        guard let name = name,
            let phoneNumber = phoneNumber,
            let email = email else {return}
        contact.name = name
        contact.phoneNumber = phoneNumber
        contact.email = email

        guard let record = CKRecord(contact: contact) else {return}
        ckmodifier.recordsToSave = [record]
        ckmodifier.savePolicy = .changedKeys
        ckmodifier.qualityOfService = .userInteractive
        privateDB.add(ckmodifier)
        
        
    }
    
    func deleteContact(contact: Contact, indexPath: Int, completion: @escaping (_ success: Bool)->Void){
        let ckModifier = CKModifyRecordsOperation()
        let recordID = contact.ckRecordId
        ckModifier.qualityOfService = .userInteractive
        ckModifier.recordIDsToDelete = [recordID]
        privateDB.add(ckModifier)
        self.contacts.remove(at: indexPath)
    }
    
    func fetchAllContacts(){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Contact", predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error.localizedDescription)💩💩")
            }
            guard let records = records else {return}
            let contacts = records.compactMap{Contact(ckRecord: $0)}
            self.contacts = contacts
        }
    }
    
}


extension UIViewController {
    func presentAlertController(){
        let alertController = UIAlertController(title: "Something Went Wrong", message: "Check all field and try again", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true)
    }
}
