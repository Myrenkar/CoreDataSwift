//
//  MainTVC.swift
//  CD-Grocery-Images
//
//  Created by Piotr Torczyski on 08/02/16.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//

import UIKit
import CoreData


class MainTVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate ).managedObjectContext
    
    var frc :  NSFetchedResultsController = NSFetchedResultsController()
    
    func fetRequest() -> NSFetchRequest {
        
        let fetchRequest = NSFetchRequest(entityName: "Item")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
    
    
    func getFRC() ->  NSFetchedResultsController {
        
        frc =  NSFetchedResultsController(fetchRequest: fetRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return frc
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frc = getFRC()
        frc.delegate = self
        
        do{
            try frc.performFetch()
        }
        catch{
            print("Failed to perfrom initial fetch")
        }

        
        self.tableView.rowHeight = 60
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "orange-bg"))
        
        self.tableView.reloadData()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        let numberOfSections = frc.sections?.count
        return numberOfSections!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let numberOfRowsInSection = frc.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.clearColor()
        }
        else {
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
            cell.textLabel?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
            cell.detailTextLabel?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        }
        
        // Configure the cell...
        
        cell.textLabel?.textColor = UIColor.darkGrayColor()
        cell.detailTextLabel?.textColor = UIColor.darkGrayColor()
        
        let item = frc.objectAtIndexPath(indexPath) as! Item
        
        cell.textLabel?.text =  item.name
        let note = item.note
        let qty = item.qty
        cell.detailTextLabel!.text = "Note: \(note!) Quanitity: \(qty!) "
        cell.imageView?.image = UIImage(data: (item.image)!)
        
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let managedObject : NSManagedObject = frc.objectAtIndexPath(indexPath) as! NSManagedObject
        managedObjectContext.deleteObject(managedObject)
        
        do{
            try managedObjectContext.save()
        }catch{
            print("Error while saving")
            
        }
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        tableView.reloadData()
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "edit"{
            let cell = sender as! UITableViewCell
            let indexPath  =  tableView.indexPathForCell(cell)
            let itemController : AddEddiVC = segue.destinationViewController as! AddEddiVC
            let item :Item = frc.objectAtIndexPath(indexPath!) as! Item
            itemController.item = item
            
            
        }
        
        
    }
}
