//
//  FirstTableViewController.swift
//  CloudKitPractice2
//
//  Created by Tatsuya Moriguchi on 4/9/19.
//  Copyright © 2019 Becko's Inc. All rights reserved.
//

import UIKit
import CloudKit

class FirstTableViewController: UITableViewController {
    
    var wisdoms = [CKRecord]()
    let database = CKContainer.default().privateCloudDatabase
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(queryDatabase), for: .valueChanged)
        self.tableView.refreshControl = refreshControl

  
        
        //setuupView()
        queryDatabase()
    
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    
    // iCloud Database Query
    
    @objc func queryDatabase() {
        //let predicate = NSPredicate(format: "%K == %@", "content", "hello")
        //let query = CKQuery(recordType: "Wisdom", predicate: predicate)
        let query = CKQuery(recordType: "Wisdom", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { (records, _) in
            guard let records = records else { return }
            let sortedRecords = records.sorted(by: { $0.creationDate! > $1.creationDate! })
            self.wisdoms = sortedRecords
            
//            self.wisdoms = records
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
/*    private func setupView() {
        tableView.hidden = true
        messageLabel.hidden = true
        activityIndicatorView.startAnimating()
    }
    
 
    private func updateView() {
        let hasRecords = self.wisdoms.count > 0
        self.tableView.isHidden = !hasRecords
        messageLabel.isHidden = hasRecords
        activityIndicatorView.stopAnimating()
        
    }
  */
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return wisdoms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WisdomCell", for: indexPath)

        let wisdom = wisdoms[indexPath.row].value(forKey: "content") as! String
        cell.textLabel?.text = wisdom
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            let recordID = wisdoms[indexPath.row].recordID
            database.delete(withRecordID: recordID) { (recordID, error) -> Void in
                guard let recordID = recordID else {
                    //print("Error deleteing record: \(error)")
                    return
                }

                print("deleted record with wisdom: \(recordID.recordName)")
            }
            
            // since iCloud is not fast, this update may take time
            FirstTableViewController().queryDatabase()

            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            print(".insert")
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! AddEditViewController

        switch segue.identifier {
        case "addSegue":
            destVC.segueID = "addSegue"
            print("addSegue")
        case "editSegue":
            destVC.segueID = "editSegue"
            //destVC.wisdom = wisdoms.wisdom
            print("editSegue")
        default:
            print("ERROR: segue is default")
            break
            
        }
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
