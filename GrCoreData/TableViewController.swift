//
//  TableViewController.swift
//  GrCoreData
//
//  Created by Grandre on 16/6/13.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit
import CoreData
class TableViewController: UITableViewController,NSFetchedResultsControllerDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var fetchResultsController:NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        // self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let fetchRequest = NSFetchRequest(entityName: "BOOK")
        /**
         必须要加入排序
         */
        let sortDesctiptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDesctiptor]
        
        self.fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.appDelegate.managedObjectContext, sectionNameKeyPath: "name", cacheName: nil)
        self.fetchResultsController.delegate = self
        do{
            try fetchResultsController.performFetch()
        }catch let error as NSError{
            print("Error:\(error.localizedDescription)")
        }
        
    }
    /**
     下面四个方法属于NSFetchedResultsController代理。
     */
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    /**
     如果涉及到section的增加删除，就必须实现此代理方法
     */
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        if type == NSFetchedResultsChangeType.Delete{
            self.tableView.deleteSections(NSIndexSet.init(index: sectionIndex), withRowAnimation: .Fade)
        }
    }
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            if let _newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([_newIndexPath], withRowAnimation: .Automatic)
            }
            break
        case .Delete:

            if let _indexPath = indexPath {
                self.tableView.deleteRowsAtIndexPaths([_indexPath], withRowAnimation: .Automatic)
             
            }

           break
        case .Update:
            if let _indexPath = indexPath {
                tableView.reloadRowsAtIndexPaths([_indexPath], withRowAnimation: .Automatic)
            }
        default:
            tableView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    //必须要为footer设置高度>=1，才能后面设置footview。
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    /**
     如果是最后一个section，则返回uiview，可以把后面的空cell去掉。
     */
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return section == (self.fetchResultsController.sections?.count)! - 1 ?UIView():nil
    }
    /**
    这是直接返回fetchResultsController.sections?.count，充分利用fetchResultsController带来的便利
     */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (fetchResultsController.sections?.count)!

    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return fetchResultsController.sections![section].numberOfObjects
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
    
        // Configure the cell...
        let object = fetchResultsController.objectAtIndexPath(indexPath) as! BOOK
        cell.textLabel?.text = object.name
        cell.detailTextLabel?.text = object.price?.stringValue

        return cell
        
        
    }
 

// 默认全部可编辑
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    /**
     如果自定义了editActionsForRowAtIndexPath，下面这个代理不会再执行
     */
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
          let object =  self.fetchResultsController.objectAtIndexPath(indexPath)
            self.appDelegate.managedObjectContext.deleteObject(object as! NSManagedObject)
            do{
                try self.appDelegate.managedObjectContext.save()
            }catch{
                
            }
        
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let 分享行为 = UITableViewRowAction(style: .Default, title: "分享") { (action, indexPath) -> Void in
            
            let alert = UIAlertController(title: "分享到",message: "请选择您要分享的社交类型", preferredStyle: .ActionSheet)
            
            let qqAction = UIAlertAction(title: "qq",style: .Default, handler: nil)
            let weiboAction = UIAlertAction(title: "微博",style: .Default, handler: nil)
            let wxAction = UIAlertAction(title: "微信",style: .Default, handler: nil)
            
            alert.addAction(qqAction)
            alert.addAction(weiboAction)
            alert.addAction(wxAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        分享行为.backgroundColor = UIColor(red: 218/255, green: 225/255, blue: 218/255, alpha: 1)
        
        
        let 删除行为  = UITableViewRowAction(style: .Default, title: "删除") { (action, indexPath) -> Void in
            let buffer = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
            
            let restaurantToDel = self.fetchResultsController.objectAtIndexPath(indexPath) as! BOOK
            
            buffer?.deleteObject(restaurantToDel)
            
            do {
                try buffer?.save()
            } catch {
                print(error)
            }
            
        }
        
        return [分享行为, 删除行为]
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



}
