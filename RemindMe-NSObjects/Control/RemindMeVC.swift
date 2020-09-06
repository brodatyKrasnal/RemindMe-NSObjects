//
//  RemindMe-NSObjects : RemindMeVC.swift by tymek on 27/08/2020 17:57.
//  Copyright © 2020  Tymon Golęba Frygies. All rights reserved.


import UIKit

class RemindMeVC: UITableViewController {
    
    var notes = [Memo]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("RemindMe-NSCoder.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath!)
        loadItems()
        
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let brick = tableView.dequeueReusableCell(withIdentifier: K.brick, for: indexPath)
        brick.textLabel?.text = notes[indexPath.row].memoName
        
        //this will trigger the display part.
        //accessory type is associated to data value and evaluated
        brick.accessoryType = notes[indexPath.row].memoCheck == true ? .checkmark : .none
        brick.textLabel?.textColor = notes[indexPath.row].memoCheck == true ? .gray : .black
        return brick
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let brick = tableView.dequeueReusableCell(withIdentifier: K.brick, for: indexPath)
        //this will trigger change in the data
        notes[indexPath.row].memoCheck = !notes[indexPath.row].memoCheck
        
        notes[indexPath.row].memoCheck == true ? brick.textLabel?.textColor = UIColor(named: "red"): nil
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        saveData()
    }
    
    //MARK: - Add New Item
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var userText = UITextField()
        
        let alert = UIAlertController(title: "Add new list item", message: "Add new item to your list.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newItem = Memo()
            newItem.memoName = userText.text!
            self.notes.append(newItem)
            
            self.saveData()
            self.tableView.reloadData()
        }
        alert.addTextField { (alertField) in
            alertField.placeholder = "Add your item here."
            alertField.textAlignment = .center
            userText = alertField
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (cancel) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func saveData () {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.notes)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error while conding data: \(error)")
        }
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                notes = try decoder.decode([Memo].self, from: data)
            } catch {
                print("Error while decoding data: \(error)")
            }
        }
    }
    
    
    
}
