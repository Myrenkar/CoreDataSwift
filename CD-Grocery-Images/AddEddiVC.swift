//
//  AddEddiVC.swift
//  CD-Grocery-Images
//
//  Created by Piotr Torczyski on 08/02/16.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//

import UIKit
import CoreData


class AddEddiVC: UIViewController, NSFetchedResultsControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var item : Item? = nil
    
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemNote: UITextField!
    @IBOutlet weak var itemQuantity: UITextField!
    @IBOutlet weak var imageHolder: UIImageView!
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if item != nil {
        
        itemName.text = item?.name
            itemNote.text = item?.note
            itemQuantity.text = item?.qty
            imageHolder.image = UIImage(data: (item?.image)!)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        if item != nil{
            editItem()
        }
        else{
            createNewItem()
        }
        
        dismissVC()
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
         dismissVC()
    }
    
    @IBAction func addImageFromDevice(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        
        pickerController.delegate = self
        
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        pickerController.allowsEditing = true
        
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func addImageFromCamera(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        
        pickerController.delegate = self
        
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        pickerController.allowsEditing = true
        
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.imageHolder.image = image
    }
    
    
    func dismissVC(){
        
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    func createNewItem(){
        
        let entityDescription =  NSEntityDescription.entityForName("Item", inManagedObjectContext: managedObjectContext)
        
        let item = Item(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        item.name = itemName.text
        item.note  = itemNote.text
        item.qty = itemQuantity.text
        item.image = UIImagePNGRepresentation(imageHolder.image!)
        
        
        do{
            try managedObjectContext.save()
        }
        catch{
            
            print("Error saving")
            return
            
        }
        
    }
    
    
    func editItem() {
        
        item?.name = itemName.text
        item?.note = itemNote.text
        item?.qty = itemQuantity.text
        item?.image = UIImagePNGRepresentation(imageHolder.image!)
        
        
        do{
            try managedObjectContext.save()
            
        }
        catch{
            print("error while savinh")
            return
        }
    }
    
}
