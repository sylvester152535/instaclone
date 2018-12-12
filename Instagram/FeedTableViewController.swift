//
//  FeedTableViewController.swift
//  Instagram
//
//  Created by Sylvester Amponsah on 11/1/18.
//  Copyright © 2018 Sylvester Amponsah. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController {

    var users = [String: String]()
    var comments  = [String]()
    var usernames = [String]()
    var imageFiles = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let query = PFUser.query()
        
        query?.whereKey("username", notEqualTo: PFUser.current()?.username!)
        
        query?.findObjectsInBackground(block: {(objects, errors) in
            
            if let users = objects {
                
                for object in users {
                    
                    if let users = objects as? PFUser {
                        self.users[users.objectId!] = users.username!
                        
                    }
            
                }
                
            }
            
            let getFollowedUsersQuery = PFQuery(className: "Following")
            
            getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.current()?.objectId)
            getFollowedUsersQuery.findObjectsInBackground(block: {(objects, error) in
                
                if let followers = objects {
                    
                    for fowllower in followers {
                        
                        let query = PFQuery(className: "Post")
                        
                        query.whereKey("userid", equalTo: "followedUser")
                        
                        query.findObjectsInBackground(block: {(objects, error) in
                        
                        if let posts = objects {
                        
                            for post in posts {
                        
                                //Before production: Use if let blocks for these
                                
                                self.comments.append(post["message"] as! String)
                                
                                self.usernames.append(self.users[post["userid"] as! String]!)
                                
                                self.imageFiles.append(post["imageFIle"] as! PFFile)
                                
                                self.tableView.reloadData()
                        
                            }
                        
                        }
                        
                        })
                        
                    }
                    
                    
                }
                
            })
            
            
            
        })
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! FeedTableViewCell

        //Configure the cell...
        
        imageFiles[indexPath.row].getDataInBackground(block: {(data, error) in
            
            if let imageData = data {
                
                if let imageToDisplay = UIImage(data: imageData) {
                    
                    cell.postedImage.image = imageToDisplay
                    
                }
                
            }
        })
        
        
        cell.postedImage.image = UIImage(named: "museum.jpg")
        cell.comment.text = comments[indexPath.row]
        
        cell.userInfo.text = usernames[indexPath.row]

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
