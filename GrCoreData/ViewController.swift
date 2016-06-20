//
//  ViewController.swift
//  GrCoreData
//
//  Created by Grandre on 16/6/13.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var btn1:UIButton!
    var btn2:UIButton!
    var nameTextF:UITextField!
    var priceTextF:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.barStyle = .Black
        
        btn1 = UIButton(frame: CGRectMake(10,100,200,30))
        btn1.backgroundColor = UIColor.blueColor()
        btn1.setTitle("Next Page", forState: .Normal)
        btn1.addTarget(self, action: #selector(self.presentNextView), forControlEvents: .TouchUpInside)
        self.view.addSubview(btn1)
        
        btn2 = UIButton(frame: CGRectMake(10,250,200,30))
        btn2.backgroundColor = UIColor.blueColor()
        btn2.setTitle("保存", forState: .Normal)
        btn2.addTarget(self, action: #selector(self.save), forControlEvents: .TouchUpInside)
        self.view.addSubview(btn2)
        
        self.nameTextF = UITextField(frame: CGRectMake(10, 150, 200, 30))
        self.nameTextF.backgroundColor = UIColor.brownColor()
        self.view.addSubview(self.nameTextF)
        
        self.priceTextF = UITextField(frame: CGRectMake(10, 200, 200, 30))
        self.priceTextF.backgroundColor = UIColor.brownColor()
        self.view.addSubview(self.priceTextF)
        
        
        zeng增()
        zeng增2()
        cha查()
        shan删()
        cha查()
    }
    
    func presentNextView(){
        let vc = TableViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     把两个textfield的值保存起来
     */
    func save(){
        let object = NSEntityDescription.insertNewObjectForEntityForName("BOOK", inManagedObjectContext: appDelegate.managedObjectContext)
        object.setValue(self.nameTextF.text, forKey: "name")
        object.setValue(Float(self.priceTextF.text!), forKey: "price")
        appDelegate.saveContext()
    }
    /**
     zeng增()
     */
    func zeng增(){
        //向指定实体中插入托管对象,也可以理解为对象的实例化
        let object = NSEntityDescription.insertNewObjectForEntityForName("BOOK", inManagedObjectContext: appDelegate.managedObjectContext)
        object.setValue("grandre", forKey: "name")
        object.setValue(1.211, forKey: "price")
        appDelegate.saveContext()
    }
    /**
     zeng增2()，第二种增加实例的方法，前提是有生成对应的类。推荐此方法，可充分利用类的属性功能。
     */
    func zeng增2(){
        let entity = NSEntityDescription.entityForName("BOOK", inManagedObjectContext: appDelegate.managedObjectContext)
        let book2 = BOOK(entity: entity!, insertIntoManagedObjectContext: appDelegate.managedObjectContext)
        book2.name = "grandre"
        book2.price = 3.3
        appDelegate.saveContext()
    }
    /**
     cha查()
     */
    func cha查(){
        //首先，规定获取数据的实体
        let request = NSFetchRequest(entityName: "BOOK")
        //配置查询条件，如果有需要还可以配置结果排序
        let predicate = NSPredicate(format: "%K == %@", "name", "grandre")
        request.predicate = predicate
        var result:[NSManagedObject] = []
        do{
            //进行查询，结果是一个托管对象数组
            result = try appDelegate.managedObjectContext.executeFetchRequest(request) as! [NSManagedObject]
        } catch {}
        print(result.count)
        for item in result {
            //用键值对的方式获取各个值
             print( "书名：\(item.valueForKey("name") as! String)  价格：\(item.valueForKey("price") as! NSNumber)\n")
        }
    }

    /**
     shan删()，其实就是先查后删除
     */
    func shan删(){
        let request = NSFetchRequest(entityName: "BOOK")
        let predicate = NSPredicate(format: "%K == %@","name", "grandre")
        request.predicate = predicate
        var result:[NSManagedObject] = []
            do{
                result = try appDelegate.managedObjectContext.executeFetchRequest(request) as! [NSManagedObject]
            } catch {}
            if result.count != 0{
                for item in result {
                    appDelegate.managedObjectContext.deleteObject(item)
                print("delete imte \(item)")
                }
            }
        appDelegate.saveContext()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

