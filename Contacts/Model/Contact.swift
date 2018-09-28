//
//  Contact.swift
//  Contacts
//
//  Created by Levi Linchenko on 28/09/2018.
//  Copyright © 2018 Levi Linchenko. All rights reserved.
//

import Foundation
import CloudKit

class Contact {
    
    var name: String
    var phoneNumber: String
    var email: String
    var ckRecordId: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)
    
    init (name: String, phoneNumber: String, email: String){
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
    }
    
    convenience init?(ckRecord: CKRecord){
        guard let name = ckRecord["Name"] as? String,
            let email = ckRecord["Email"] as? String,
            let phoneNumber = ckRecord["PhoneNumber"] as? String else {return nil}
        self.init(name: name, phoneNumber: phoneNumber, email: email)
        self.ckRecordId = ckRecord.recordID
    }
    
}

extension CKRecord {
    convenience init?(contact: Contact){
        self.init(recordType: "Contact", recordID: contact.ckRecordId)
        self.setValue(contact.name, forKey: "Name")
        self.setValue(contact.email, forKey: "Email")
        self.setValue(contact.phoneNumber, forKey: "PhoneNumber")
    }
    
}
