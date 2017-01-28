//
//  ViewController.swift
//  SqliteDatabaseSingleton
//
//  Created by Pankaj on 24/11/16.
//  Copyright © 2016 Pankaj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createTable()
    }

    func createTable() {
        let createTableString = "CREATE TABLE Student(" +
            "Id INT PRIMARY KEY NOT NULL," +
            "Name CHAR(255)," + "image CHAR(1000));"
        DatabaseManager.sharedInstance().createTable(strCreateTableString: createTableString)
    }
    
    func fetch() {
        let queryStatementString = "SELECT * FROM Student;"
        DatabaseManager.sharedInstance().fetchUser(strQuery: queryStatementString)
    }
    
    func update() {
        let updateStatementString = "UPDATE Student SET Name = 'Pankaj' WHERE Id = 5;"
        DatabaseManager.sharedInstance().update(strQuery: updateStatementString)
    }
    
    func delete() {
        let deleteStatementStirng = "DELETE FROM Student WHERE Id = 5;"
        DatabaseManager.sharedInstance().delete(strQuery: deleteStatementStirng)
    }

}
