//
//  ViewController.swift
//  Anasthesia
//
//  Created by Debanik Purkayastha on 6/19/18.
//  Copyright © 2018 DT4. All rights reserved.
//

import UIKit

class ViewController: UITableViewController{
    
    let cellid = "cellid"
   
    var anestheticNames : [String] = []
    
    var InjectionType2DArray: [ExpandableNames] = []
    var anestheticFactory: AnestheticFactory?
    
    init(anestheticFactory: AnestheticFactory) {
        self.anestheticFactory = anestheticFactory
        anestheticNames += anestheticFactory.getAnestheticNames().sorted()
        for anestheticName in anestheticNames {
            InjectionType2DArray.append(ExpandableNames(isExpanded: true, names: anestheticFactory.getTypes(for: anestheticName)!))
        }
        super.init(style: UITableView.Style.plain)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Select Anesthetics"
        

        let largeTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 35)]
        let smallTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)]
        
        navigationController?.navigationBar.largeTitleTextAttributes = largeTextAttributes
        navigationController?.navigationBar.titleTextAttributes = smallTextAttributes
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.37, blue:0.72, alpha:1.0)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.toolbar.barTintColor = UIColor(red:0.00, green:0.37, blue:0.72, alpha:1.0)
        
        let next = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(getSelectedAnesthetics))
        next.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)], for: .normal)
        
        var items = [UIBarButtonItem]()
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        items.append(
            next
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        self.toolbarItems = items
        tableView.allowsMultipleSelection = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellid)
        let clearView = UIView()
        clearView.backgroundColor = .clear
        UITableViewCell.appearance().selectedBackgroundView = clearView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // over ride
        return InjectionType2DArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton(type: .custom)
        button.setTitle("\(self.anestheticNames[section])", for: .normal)
        button.backgroundColor = UIColor(red:0.41, green:0.67, blue:0.90, alpha:1.0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitleColor(.white, for: .normal)
        button.tag = section
        button.contentHorizontalAlignment = .left
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red:0.00, green:0.37, blue:0.72, alpha:1.0).cgColor
        let origImage = UIImage(named: "syringe-4")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = UIColor(red:0.00, green:0.37, blue:0.72, alpha:1.0)
        button.imageEdgeInsets = UIEdgeInsets.init(top: CGFloat(0), left: CGFloat(10), bottom: CGFloat(0),right: CGFloat(0))
        button.titleEdgeInsets = UIEdgeInsets.init(top: CGFloat(0), left: CGFloat(20), bottom: CGFloat(0),right: CGFloat(0))
        button.adjustsImageWhenHighlighted = false
        return button
    }
    
    @objc func getSelectedAnesthetics(_ sender: UIButton) {
        var anesthetics : [Anesthetic] = []
        let selectedRows = tableView.indexPathsForSelectedRows
        if (selectedRows == nil) {
            return
        }
        for pair in selectedRows! {
            let name = (anestheticNames[pair[0]])
            let type = (InjectionType2DArray[pair[0]].names[pair[1]])
            anesthetics.append((anestheticFactory?.getAnesthetic(name: name, type: type))!)
        }
        self.navigationController!.pushViewController(ConcentrationController(anesthetics: anesthetics), animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == InjectionType2DArray.count) {
            return 0
        }
        
        return (InjectionType2DArray[section].names.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
        
        let injectionName = InjectionType2DArray[indexPath.section].names[indexPath.row]
        cell.textLabel?.text = injectionName
        cell.contentView.backgroundColor = .white
    
        cell.accessoryView?.isHidden = true
        let selectedIndexPaths = tableView.indexPathsForSelectedRows
        let rowIsSelected = selectedIndexPaths != nil && selectedIndexPaths!.contains(indexPath)
        cell.accessoryType = rowIsSelected ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        if (tableView.indexPathsForSelectedRows?.count == 1) {
            self.navigationController?.setToolbarHidden(false, animated: true)
        }
        cell.accessoryType = .checkmark
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        if (tableView.indexPathsForSelectedRows == nil) {
            self.navigationController?.setToolbarHidden(true, animated: true)
        }
        cell.accessoryType = .none
        // cell.accessoryView.hidden = true  // if using a custom image
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
}

