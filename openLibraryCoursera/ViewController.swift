//
//  ViewController.swift
//  openLibraryCoursera
//
//  Created by Jonathan Silva on 24/04/17.
//  Copyright © 2017 Jonathan Silva. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var books = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "LIBROS"
        self.tableView.reloadData()
    }
    
    
    // MARK: - Delegates

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! BookTableViewCell
        
        let book = self.books.object(at: indexPath.row) as! Book
        
        if books.count > 0 {
            cell.bookTitle.text = book.titulo
            cell.bookSubtitle.text = book.autor
            let url = NSURL(string: book.cover)
            let imageData = NSData(contentsOf: url! as URL)
            cell.bookImage.alpha = 1
            cell.bookImage.image = UIImage(data: imageData! as Data)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailBook", sender: indexPath.row)
    }
    
    
    // MARK: - Functions
    
    @IBAction func AddBook(_ sender: Any) {
        self.performSegue(withIdentifier: "addBook", sender: nil)
    }
    
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "addBook"){
            let nextViewController = segue.destination as! AddViewController
            nextViewController.books = books
        }
        
        if(segue.identifier == "detailBook"){
            
            let book = self.books.object(at: (tableView.indexPathForSelectedRow?.row)!) as! Book
            
            let nextViewController = segue.destination as! BookViewController
            nextViewController.book = book
        }
    }
}

