//
//  ViewController.swift
//  Anesthesia
//
//  Created by Taha Baig on 07/14/18.
//  Copyright © 2018 DT4. All rights reserved.
//

import UIKit

class ComorbidityController: UITableViewController{
    
    let cellid = "comorbidities"
    let comorbidityNames :  [String]
    var selectedComorbidites : SelectedComorbidities
    var youngAgeComorbidity : UIButton? = nil
    var oldAgeComorbidity : UIButton? = nil

    init(names:  [String], selected: SelectedComorbidities) {
        self.comorbidityNames = names
        self.selectedComorbidites = selected
        super.init(style: UITableView.Style.plain)
    }
    
    required init?(coder: NSCoder) {
        self.comorbidityNames = []
        selectedComorbidites = SelectedComorbidities()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Comorbidities"

        let largeTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 35)]
        let smallTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)]
        
        navigationController?.navigationBar.largeTitleTextAttributes = largeTextAttributes
        navigationController?.navigationBar.titleTextAttributes = smallTextAttributes
        
        navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.37, blue:0.72, alpha:1.0)
        navigationController?.navigationBar.tintColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellid)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return comorbidityNames.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        let button = UIButton(type: .custom)
        button.setTitle(self.comorbidityNames[section], for: .normal)
        if (self.comorbidityNames[section] == "Age: < 4 Months") {
            self.youngAgeComorbidity = button
        }
        if (self.comorbidityNames[section] == "Age: > 70 years") {
            self.oldAgeComorbidity = button
        }
        button.backgroundColor = UIColor(red:0.41, green:0.67, blue:0.90, alpha:1.0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .left
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red:0.00, green:0.37, blue:0.72, alpha:1.0).cgColor
        let origImage = UIImage(named: "square-32")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        let checkImage = UIImage(named: "ok")
        let tintedCheck = checkImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedCheck, for: .selected);
        if (self.selectedComorbidites.set.contains(self.comorbidityNames[section])) {
            button.isSelected = true
        }
        button.imageView?.layer.borderColor = UIColor.white.cgColor
        button.imageView?.layer.borderWidth  = 2.0
        button.addTarget(self, action: #selector(selectComorbidity), for: .touchUpInside)
        button.tintColor = .black
        button.tag = section
        button.adjustsImageWhenHighlighted = false
        button.imageEdgeInsets = UIEdgeInsets.init(top: CGFloat(0), left: CGFloat(10), bottom: CGFloat(0),right: CGFloat(0))
        button.titleEdgeInsets = UIEdgeInsets.init(top: CGFloat(0), left: CGFloat(20), bottom: CGFloat(0),right: CGFloat(0))
        return button
    }
    
      @objc func selectComorbidity(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if (sender === youngAgeComorbidity
            && sender.isSelected
            && (oldAgeComorbidity?.isSelected ?? false)) {
            
            oldAgeComorbidity!.isSelected = false
            self.selectedComorbidites.set.remove("Age: > 70 years")
        }
        
        if (sender === oldAgeComorbidity
            && sender.isSelected
            && (youngAgeComorbidity?.isSelected ?? false)) {
            
            youngAgeComorbidity!.isSelected = false
            self.selectedComorbidites.set.remove("Age: < 4 Months")
        }
        
        if (sender.isSelected) {
            self.selectedComorbidites.set.insert(self.comorbidityNames[sender.tag])
        } else {
            self.selectedComorbidites.set.remove(self.comorbidityNames[sender.tag])
        }
        return
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }

    
}

