//
//  DataManager.swift
//  Challenge7
//
//  Created by Anmol Kalra on 02/08/21.
//

import Foundation

class DataManager {
	static let instance = DataManager()
	
	func encodeData(using dataSource: [NoteDataModel]) {
		let jsonEncoder = JSONEncoder()
		if let saveData = try? jsonEncoder.encode(dataSource) {
			let defaults = UserDefaults.standard
			defaults.setValue(saveData, forKey: "notes")
		} else {
			print("Failed to encode data!")
		}
	}
	
	func decodeData(using data: Data?, completion: @escaping([NoteDataModel]) -> Void) {
		//retrieve data from user defaults and setup app data, remove dummy json later
		
		///`from local dummy file`
//		guard let path = Bundle.main.url(forResource: "Dummy", withExtension: "json") else { return }
//		do {
//			let data = try Data(contentsOf: path)
//			let decodedData = try JSONDecoder().decode([NoteDataModel].self, from: data)
//
//			for someData in decodedData {
//				let data = NoteDataModel(title: someData.title, note: someData.note)
//				dummyData.append(data)
//			}
//			completion(dummyData)
//		} catch {
//			print(error)
//		}
		
		///`from data object`
		
		do {
			guard let safeData = data else { return }
			let json = try JSONDecoder().decode([NoteDataModel].self, from: safeData)
			completion(json)
		} catch {
			print(error)
		}
	}
}
