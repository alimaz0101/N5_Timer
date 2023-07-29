//
//  ViewController.swift
//  Timestamp
//
//  Created by Alima Zhaksylyk on 20.07.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    } ()
    
    private var models = [ListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "List"
        view.addSubview(tableView)
        getAllItems()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Item",
                                      message: "Enter new item",
                                      preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self?.createItem(name: text)
        }))
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            let createdAtString = dateFormatter.string(from: model.createdAt ?? Date())
        
        cell.textLabel?.text = "\(model.name ?? "") - \(createdAtString)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = models[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        let sheet = UIAlertController(title: "Edit",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            
            let alert = UIAlertController(title: "Edit Item",
                                          message: "Enter your item",
                                          preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }
                self?.updateItem(item: item, newName: newName)
            }))
            
            self.present(alert, animated: true)
            
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))
        
        present(sheet, animated: true)
    }
    
    func getAllItems() {
        let fetchRequest: NSFetchRequest<ListItem> = ListItem.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            models = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            
        }
    }
    
    func createItem(name: String) {
        let newItem = ListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        
        do{
            try context.save()
            getAllItems()
        }
        catch {
            
        }
    }
    
    func deleteItem(item: ListItem) {
        
        context.delete(item)
        do{
            try context.save()
            getAllItems()
        }
        catch {
            
        }
    }
    
    func updateItem(item: ListItem, newName: String) {
        
        item.name = newName
        
        do{
            try context.save()
            getAllItems()
        }
        catch {
            
        }
    }
}
