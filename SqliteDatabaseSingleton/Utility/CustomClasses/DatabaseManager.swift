
//
//  DatabaseManager.swift
//  SqliteDatabaseSingleton
//
//  Created by Pankaj on 24/11/16.
//  Copyright © 2016 Pankaj. All rights reserved.
//

import Foundation

class DatabaseManager {
    static var instance: DatabaseManager?
    
    var documentDirectory: String?
    var databaseFilename: String = "StudentDB.sqlite"

    init() {
        copyDatabaseIntoDocumentsDirectory()
    }
    
    static func sharedInstance() -> DatabaseManager {
        if self.instance == nil {
            self.instance = DatabaseManager()
        }
        return self.instance!
    }

    
    //MARK: ========= Prepare For Database, Open and Copy ============
    func getDatabasePath() -> String {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        documentDirectory = path
        let destinationPath: String = (self.documentDirectory?.stringByAppendingPathComponent(pathComponent: databaseFilename))!
        return destinationPath
    }
    
    func copyDatabaseIntoDocumentsDirectory() {
        var directory: ObjCBool = ObjCBool(false)
        let exists: Bool = FileManager.default.fileExists(atPath: getDatabasePath(), isDirectory: &directory)
        
        if exists {
            print("Already available")
        } else {
            let strsourcePath = Bundle.main.resourcePath?.stringByAppendingPathComponent(pathComponent: databaseFilename)
            do {
                print("copy from main bundle")
                try
                    FileManager.default.copyItem(atPath: strsourcePath!, toPath: getDatabasePath())
            } catch let error as NSError {
                print("error : \(error)")
            }
        }
    }
    
    func openDatabase() -> OpaquePointer {
        var db: OpaquePointer? = nil
        if sqlite3_open(getDatabasePath(), &db) == SQLITE_OK {
            print(" Database path: \(getDatabasePath())")
            return db!
        } else {
            print("Unable to open database.")
            return db!
        }
    }

    
    //MARK: ========= Create Table =============
    func createTable(strCreateTableString: String) {
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(openDatabase(), strCreateTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Table has been created.")
            } else {
                print("Unable to create table.")
            }
        } else {
            print("Create statement error")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    //MARK: ========= Insert Values =============
    func insertUser(user:User) {
        var insertStatement: OpaquePointer? = nil
        let strInsertQuerry = "INSERT INTO Student (Id, Name, image) VALUES (?, ?, ?);"
        if sqlite3_prepare_v2(openDatabase(), strInsertQuerry, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(user.strId!)!)
            sqlite3_bind_text(insertStatement, 2, user.strName!, -1, nil)
            sqlite3_bind_text(insertStatement, 3, user.strImageLocalPath!, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted a row.")
            } else {
                print("Could not insert a row.")
            }
        } else {
            print("Insert statement error")
        }
        sqlite3_finalize(insertStatement)
    }
    
    
    //:MARK: ========= Fetch Records =========
    func fetchUser(strQuery: String) {
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(openDatabase(), strQuery, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                print(id)
            }
        } else {
            print("Unable to create fetch statement")
        }
        sqlite3_finalize(queryStatement)
    }
    
    
    //:MARK: ========= Update Records =========
    func update(strQuery: String) {
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(openDatabase(), strQuery, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("Unable to prepare update statement")
        }
        sqlite3_finalize(updateStatement)
    }
    
    
    //:MARK: ========= Delete Records =========
    func delete(strQuery: String) {
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(openDatabase(), strQuery, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Row deleted successfully.")
            } else {
                print("Unable to delete row.")
            }
        } else {
            print("Unable to prepare delete statement")
        }
        sqlite3_finalize(deleteStatement)
    }

}

extension String {
    func stringByAppendingPathComponent(pathComponent: String) -> String {
        return (self as NSString).appendingPathComponent(pathComponent)
    }
}
