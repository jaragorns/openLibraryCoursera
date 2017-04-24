//
//  AddViewController.swift
//  openLibraryCoursera
//
//  Created by Jonathan Silva on 24/04/17.
//  Copyright © 2017 Jonathan Silva. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookAutores: UILabel!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var books : NSMutableArray!
    var barButtonSave : UIBarButtonItem!
    var autores = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        bookTitle.text = ""
        bookAutores.text = ""
    }
    
    
    // MARK: - Functions

    @IBAction func searchBook(_ sender: Any) {
        let book = Book()
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
        let url = NSURL(string: urls + textField.text!)
        let datos = NSData(contentsOf: url! as URL) as Data?
        
        let num = Int(self.textField.text!)
        if num != nil {
            print("Valid Integer")
        }
        else {
            print("Not Valid Integer")
        }
        
        if datos == nil {
            
            let alertController = UIAlertController(title: "Error", message:"Error de comunicación.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        } else if num == nil {
            
            let alertController = UIAlertController(title: "Error", message:"ISBN Solo acepta numeros.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        } else if (self.textField.text?.characters.count)! < 10 || (self.textField.text?.characters.count)! > 12  || (self.textField.text?.characters.count)! == 11 {
            
            let alertController = UIAlertController(title: "Error", message:"ISBN Codigo de 10 o 12 numeros.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        }else{
            
            do{
                let json = try! JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                
                for item in json {
                    //TITLE
                    let dict = item.value as! NSDictionary
                    self.bookTitle.text = (dict["title"] as? String)!
                    book.titulo = self.bookTitle.text!
                    //AUTHORS
                    if dict["authors"] as? NSArray != nil {
                        let authors = (dict["authors"] as? NSArray)!
                        autores = ""
                        for author in authors {
                            let autor = author as! NSDictionary
                            autores += autor["name"]! as! String
                            autores += "\n"
                        }
                    }else{
                        autores = "Sin Autor"
                    }
                    self.bookAutores.text = autores
                    book.autor = autores
                    autores = ""
                    //COVER
                    let covers = (dict["cover"] as? NSDictionary)!
                    for cover in covers {
                        if cover.key as? String == "small" {
                            let url = NSURL(string: (cover.value as? String)!)
                            let imageData = NSData(contentsOf: url! as URL)
                            bookImage.alpha = 1
                            bookImage.image = UIImage(data: imageData! as Data)
                            book.cover = (cover.value as? String)!
                        }
                    }
                }
                self.books.add(book)
                
            }catch let _ as NSError {
                
                let alertController = UIAlertController(title: "Error", message:"Error en lectura.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    func backView() {
        self.performSegue(withIdentifier: "mainView", sender: nil)
    }
    
    func setupNavigationBar() {
        
        barButtonSave = UIBarButtonItem(title: "Volver", style: .plain, target: self, action:#selector(AddViewController.backView))
        let saveAttrs = [ NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "Avenir-Light", size: 15.0)!]
        barButtonSave.setTitleTextAttributes(saveAttrs, for: .normal)
        self.navigationItem.leftBarButtonItem = barButtonSave
        
        self.navigationItem.title = "BUSCAR LIBRO"
        self.navigationItem.title = self.navigationItem.title?.uppercased()
        
        let fontAttrs = [ NSForegroundColorAttributeName: UIColor.black,
                          NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 15.0)!]
        
        UINavigationBar.appearance().titleTextAttributes = fontAttrs
        UINavigationBar.appearance().barTintColor = UIColor.white
        
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "mainView"){
            let nav = segue.destination as! UINavigationController
            let nextViewController = nav.topViewController as! ViewController
            nextViewController.books = books
        }
    }
    
}
