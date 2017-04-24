//
//  BookViewController.swift
//  openLibraryCoursera
//
//  Created by Jonathan Silva on 24/04/17.
//  Copyright © 2017 Jonathan Silva. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAutores: UILabel!
    
    var book = Book()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "DETALLE LIBRO"
        bookTitle.text = book.titulo
        bookAutores.text = book.autor
        let url = NSURL(string: book.cover)
        let imageData = NSData(contentsOf: url! as URL)
        bookImage.alpha = 1
        bookImage.image = UIImage(data: imageData! as Data)
    }
    
}
