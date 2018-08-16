//
//  PatientProfileController.swift
//  Anesthesia
//
//  Created by Taha Baig on 7/8/18.
//  Copyright © 2018 DT4. All rights reserved.
//

import UIKit

class PatientProfileViewController: UIViewController {
    
    var anesthetics : [Anesthetic] = []
    let comorbiditesList : [String] = Comorbidities().names
    var selectedComorbidities : SelectedComorbidities = SelectedComorbidities()
    let weightInput = UITextField()
    let weightUnitSegmentControl = UISegmentedControl(items: ["KG", "LB"])
    let resultValue = UILabel()
    
    init(anesthetics: [Anesthetic]) {
        self.anesthetics = anesthetics
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HERE HERE HERE HERE HERE HERE HERE")
        print(anesthetics)
        view.backgroundColor = .white

        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Patient Profile"
        
        let stackView = UIStackView()
        
        let weightStackView = UIStackView()
        weightStackView.translatesAutoresizingMaskIntoConstraints = false
        weightStackView.axis = .horizontal
        
        let weightLabel = UILabel()
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.text = " Weight "
        weightLabel.adjustsFontSizeToFitWidth = true
        weightLabel.textColor = .white
        weightLabel.font = UIFont.boldSystemFont(ofSize: 25)
        weightLabel.backgroundColor = UIColor(red:0.41, green:0.67, blue:0.90, alpha:1.0)
        weightLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 4).isActive = true
        weightLabel.textAlignment = .center

        weightInput.textAlignment = .center
        weightInput.translatesAutoresizingMaskIntoConstraints = false
        weightInput.layer.borderColor = UIColor(red:0.41, green:0.67, blue:0.90, alpha:1.0).cgColor
        weightInput.layer.borderWidth = 1.0
        weightInput.widthAnchor.constraint(equalToConstant: view.frame.width / 2)
        weightInput.keyboardType = UIKeyboardType.decimalPad
        
        let blankUIView = UIView()
        blankUIView.translatesAutoresizingMaskIntoConstraints = false
        blankUIView.backgroundColor = .clear
        blankUIView.widthAnchor.constraint(equalToConstant: view.frame.width / 12).isActive = true
        
        weightUnitSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        weightUnitSegmentControl.widthAnchor.constraint(equalToConstant: view.frame.width / 4).isActive = true
        weightUnitSegmentControl.selectedSegmentIndex = 0;
        
        weightStackView.addArrangedSubview(weightLabel)
        weightStackView.addArrangedSubview(weightInput)
        weightStackView.addArrangedSubview(blankUIView)
        weightStackView.addArrangedSubview(weightUnitSegmentControl)
        weightStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.addArrangedSubview(weightStackView)
        
        let comborbidityButton = UIButton()
        comborbidityButton.translatesAutoresizingMaskIntoConstraints = false
        comborbidityButton.setTitle("Set Comorbidities", for: .normal)
        comborbidityButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        comborbidityButton.backgroundColor = UIColor(red:0, green:0.37, blue:0.72, alpha:1.0)
        comborbidityButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        comborbidityButton.addTarget(self, action: #selector(getComorbidities), for: .touchUpInside)
        stackView.addArrangedSubview(comborbidityButton)
        
        let calcButton = UIButton()
        calcButton.translatesAutoresizingMaskIntoConstraints = false
        calcButton.setTitle("Calculate", for: .normal)
        calcButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        calcButton.backgroundColor = UIColor(red:0, green:0.37, blue:0.72, alpha:1.0)
        calcButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        calcButton.addTarget(self, action: #selector(calculateDose), for: .touchUpInside)
        stackView.addArrangedSubview(calcButton)
        
        let resultStackView = UIStackView()
        resultStackView.translatesAutoresizingMaskIntoConstraints = false
        resultStackView.axis = .horizontal
        
        let resultLabel = UILabel()
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.text = " Max Dosage (mg) "
        resultLabel.adjustsFontSizeToFitWidth = true
        resultLabel.textColor = .white
        resultLabel.font = UIFont.boldSystemFont(ofSize: 25)
        resultLabel.backgroundColor = UIColor(red:0.41, green:0.67, blue:0.90, alpha:1.0)
        resultLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
        resultLabel.textAlignment = .center
        resultStackView.addArrangedSubview(resultLabel)
        
        resultValue.adjustsFontSizeToFitWidth = true
        resultValue.textAlignment = .center
        resultValue.translatesAutoresizingMaskIntoConstraints = false
        resultValue.layer.borderColor = UIColor(red:0.41, green:0.67, blue:0.90, alpha:1.0).cgColor
        resultValue.layer.borderWidth = 1.0
        resultValue.widthAnchor.constraint(equalToConstant: view.frame.width / 4).isActive = true
        resultStackView.addArrangedSubview(resultValue)
        
        stackView.addArrangedSubview(resultStackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        self.view.addSubview(stackView)
        
        
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        //stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant:-20).isActive = true
        //stackView.heightAnchor.constraint(equalToConstant: view.frame.height/2).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func calculateDose(sender: UIButton?) {
        if var weight = Double(weightInput.text!) {
            if (weightUnitSegmentControl.selectedSegmentIndex == 1) {
                //convert pounds to kg
                weight *= 0.453592;
            }
        }
        //self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func getComorbidities(sender: UIButton) {
        self.navigationController!.pushViewController(ComorbidityController(names: comorbiditesList, selected: selectedComorbidities), animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }


}
