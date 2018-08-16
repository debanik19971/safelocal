//
//  Anesthetic.swift
//  Anesthesia
//
//  Created by Taha Baig on 7/7/18.
//  Copyright © 2018 DT4. All rights reserved.
//

import Foundation

struct Anesthetic : Codable {
    let name: String
    let type: String
    let dosageFactor: Double
    var concentration: Double? = nil
    
    func getDosage(for weight: Double, selectedComorbidities: SelectedComorbidities) -> Double {
        let weightDosage = getWeightDosage(for: weight)
        return factorComorbidities(for: weightDosage, selectedComorbidities: selectedComorbidities)
    }
    
    func getWeightDosage(for weight: Double) -> Double {
    	return dosageFactor * weight;
    }
    
    func factorComorbidities(for weightDosage: Double, selectedComorbidities: SelectedComorbidities) -> Double {
        return weightDosage
    }
}
