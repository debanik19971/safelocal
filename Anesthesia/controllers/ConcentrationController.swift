//
//  ConcentrationController.swift
//  Anesthesia
//
//  Created by Taha Baig on 07/21/18.
//  Copyright © 2018 DT4. All rights reserved.
//

import UIKit

class ConcentrationController: UITableViewController, UITextFieldDelegate {
    
    let cellid = "concentrations"
    var anesthetics : [Anesthetic] = []
    var filledTextFields : Int = 0
    var concentrationInputValues : [String] = []
    var cells : [UITableViewCell] = []
    var concentrationLabelConstraints : [NSLayoutConstraint] = []
    var concentrationInputConstraints : [NSLayoutConstraint] = []
    var percentLabelConstraints : [NSLayoutConstraint] = []
    var cellHeight : CGFloat = 0

    init(anesthetics: [Anesthetic]) {
        self.anesthetics = anesthetics
        for _ in 0..<anesthetics.count {
            concentrationInputValues.append("")
        }
        super.init(style: UITableView.Style.plain)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        for (index, anesthetic) in anesthetics.enumerated() {
            let cell = UITableViewCell()
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            let concentrationLabel = UILabel()
            concentrationLabel.translatesAutoresizingMaskIntoConstraints = false
            concentrationLabel.text = " \(anesthetic.name) - \(anesthetic.type) "
            concentrationLabel.adjustsFontSizeToFitWidth = false
            concentrationLabel.textColor = .white
            concentrationLabel.font = UIFont.boldSystemFont(ofSize: 25)
            concentrationLabel.backgroundColor = .clear
            let concentrationLabelWidthConstraint = concentrationLabel.widthAnchor.constraint(equalToConstant: 0.75 * view.frame.width)
            concentrationLabelWidthConstraint.isActive = true
            self.concentrationLabelConstraints.append(concentrationLabelWidthConstraint)
            concentrationLabel.textAlignment = .left
            
            let concentrationInput = UITextField()
            concentrationInput.translatesAutoresizingMaskIntoConstraints = false
            concentrationInput.delegate = self
            concentrationInput.tag = index
            concentrationInput.backgroundColor = .white
            concentrationInput.textAlignment = .center
            concentrationInput.layer.borderColor = UIColor(red:0.41, green:0.67, blue:0.90, alpha:1.0).cgColor
            concentrationInput.layer.borderWidth = 1.0
            let sideLength = min(0.12 * view.frame.width, 0.12 * view.frame.height)
            let concentrationInputHeightConstraint = concentrationInput.heightAnchor.constraint(equalToConstant: sideLength)
            concentrationInputHeightConstraint.isActive = true
            self.concentrationInputConstraints.append(concentrationInputHeightConstraint)
            let concentrationInputWidthConstraint = concentrationInput.widthAnchor.constraint(equalToConstant: sideLength)
            concentrationInputWidthConstraint.isActive = true
            self.concentrationInputConstraints.append(concentrationInputWidthConstraint)
            concentrationInput.keyboardType = UIKeyboardType.decimalPad
            concentrationInput.text = self.concentrationInputValues[index]
            
            let percentLabel = UILabel()
            percentLabel.translatesAutoresizingMaskIntoConstraints = false
            percentLabel.text = " % "
            percentLabel.adjustsFontSizeToFitWidth = false
            percentLabel.textColor = .white
            percentLabel.font = UIFont.boldSystemFont(ofSize: 25)
            percentLabel.backgroundColor = .clear
            let percentLabelWidthConstraint = percentLabel.widthAnchor.constraint(equalToConstant: 0.12 * view.frame.width)
            percentLabelWidthConstraint.isActive = true
            self.percentLabelConstraints.append(percentLabelWidthConstraint)
            percentLabel.textAlignment = .left
            
            stackView.addArrangedSubview(concentrationLabel)
            stackView.addArrangedSubview(concentrationInput)
            stackView.addArrangedSubview(percentLabel)
            
            cell.addSubview(stackView)
            
            cell.contentView.backgroundColor = UIColor(red:0.41, green:0.67, blue:0.90, alpha:1.0)
            
            stackView.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
            stackView.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            cells.append(cell)
        }
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        navigationItem.title = "Select Conenetrations"
        
        let next = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(setConcentrations))
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellid)
       	tableView.allowsSelection = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton(type: .custom)
        button.setTitle("Chosen Anesthetics", for: .normal)
        button.backgroundColor = UIColor(red:0.41, green:0.67, blue:0.90, alpha:1.0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitleColor(.white, for: .normal)
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
    

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (anesthetics.count)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.cellHeight = max(self.view.frame.height * 0.13, self.view.frame.width * 0.13)
        return cellHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath[1]]
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let concentration = Double(textField.text!)
        if concentration != nil {
            //account for using possibly changing text field to invalid data
            self.filledTextFields -= 1
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.concentrationInputValues[textField.tag] = textField.text!
        let concentration = Double(textField.text!)
        if concentration != nil {
            self.anesthetics[textField.tag].concentration = concentration
            self.filledTextFields += 1
            if (self.filledTextFields == anesthetics.count) {
                self.navigationController?.setToolbarHidden(false, animated: true)
            }
        } else {
            self.navigationController?.setToolbarHidden(true, animated: true)
        }
    }
    
    @objc func setConcentrations() {
        self.navigationController!.pushViewController(PatientProfileViewController(anesthetics: anesthetics), animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.filledTextFields == anesthetics.count) {
            self.navigationController?.setToolbarHidden(false, animated: false)
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: {context in
            for c in self.concentrationLabelConstraints {
                c.constant = size.width * 0.75
            }
            
            let sideLength = min(0.12 * size.width, 0.12 * size.height)
            for c in self.concentrationInputConstraints {
                c.constant = sideLength
            }
            
            for c in self.percentLabelConstraints {
                c.constant = 0.12 * size.width
            }
            
        }, completion: { context in
        })
    }
    
    
}

