//
//  AnestheticFactory.swift
//  Anesthesia
//
//  Created by Taha Baig on 7/7/18.
//  Copyright © 2018 DT4. All rights reserved.
//

import Foundation

class AnestheticFactory {
    var anestheticTypesDict : [String: [String]] = [:]
    var nameAndTypeToAnestheticDict : [String: Anesthetic] = [:]

    init(anestheticList : [Anesthetic]) {
    	for anesthetic in anestheticList {
    		if (anestheticTypesDict.keys.contains(anesthetic.name)){
    			anestheticTypesDict[anesthetic.name]!.append(anesthetic.type)
    		} else {
    			anestheticTypesDict[anesthetic.name] = [anesthetic.type]
    		}

    		let combinedName = "\(anesthetic.name),\(anesthetic.type)"
    		nameAndTypeToAnestheticDict[combinedName] = anesthetic
    	}
    }

	func getAnestheticNames() -> [String] {
		return Array(anestheticTypesDict.keys)
    }

    func getAnesthetic(name: String, type: String) -> Anesthetic? {
    	let combinedName = "\(name),\(type)"
    	return nameAndTypeToAnestheticDict[combinedName]
    }

    func getTypes(for name: String) -> [String]? {
    	return anestheticTypesDict[name]
    }

}
