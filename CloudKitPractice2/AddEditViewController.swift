//
//  AddEditViewController.swift
//  CloudKitPractice2
//
//  Created by Tatsuya Moriguchi on 4/9/19.
//  Copyright © 2019 Becko's Inc. All rights reserved.
//

import UIKit
import CloudKit

class AddEditViewController: UIViewController {

    let database = CKContainer.default().privateCloudDatabase
    var wisdom: String?
    var segueID: String?
    
    @IBOutlet weak var wisdomTextField: UITextField!
    @IBAction func saveOnTapped(_ sender: UIButton) {
 
        saveToCloud()

        navigationController!.popViewController(animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if segueID == "editSegue" {
            wisdomTextField.text = wisdom
        }
        

    }
    
    func saveToCloud() {

        let wisdom = wisdomTextField.text
        let newWisdom = CKRecord(recordType: "Wisdom")
        newWisdom.setValue(wisdom, forKey: "content")
        database.save(newWisdom) { (record, _) in
            guard record != nil else {
                print("hello")
                return }
            print("Saved record with wisdom.")
            // since iCloud is not fast, this update may take time
            FirstTableViewController().queryDatabase()
        }
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
