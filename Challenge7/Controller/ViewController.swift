//
//  ViewController.swift
//  Challenge7
//
//  Created by Anmol Kalra on 02/08/21.
//

import UIKit

class ViewController: UITableViewController {
	
	var notes = [NoteDataModel]() {
		didSet {
			tableView.reloadData()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNewNote))
		title = "Notes"
		
		let defaults = UserDefaults.standard
		if let savedNotes = defaults.object(forKey: "notes") as? Data {
			DataManager.instance.decodeData(using: savedNotes) { response in
				self.notes = response
			}
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		let defaults = UserDefaults.standard
		if let savedNotes = defaults.object(forKey: "notes") as? Data {
			DataManager.instance.decodeData(using: savedNotes) { response in
				self.notes = response
			}
		}
	}
	
	//MARK: - TableView DataSource and Delegate
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return notes.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "noteName", for: indexPath)
		cell.textLabel?.text = notes[indexPath.row].title
		cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
		cell.detailTextLabel?.text = notes[indexPath.row].note
		cell.detailTextLabel?.numberOfLines = 1
		cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		createAndShowNotesVC(for: indexPath)
	}
	
	//MARK: - Note Functions
	
	func createAndShowNotesVC(for indexPath: IndexPath) {
		guard let vc = storyboard?.instantiateViewController(withIdentifier: "notesVC") as? NoteViewController else { return }
		vc.title = notes[indexPath.row].title.capitalized
		vc.textViewText = notes[indexPath.row].note
		vc.notesData = self.notes
		vc.indexPath = indexPath
		navigationController?.pushViewController(vc, animated: true)
	}
	
	@objc func createNewNote() {
		let alert = UIAlertController(title: "Title", message: "Set a title for your note.", preferredStyle: .alert)
		alert.addTextField()
		
		alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
			guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "notesVC") as? NoteViewController else { return }
			guard let noteTitle = alert.textFields?.first?.text else { return }
			vc.title = noteTitle.capitalized
			vc.textView.text = ""
//			self.notes.append(NoteDataModel(title: noteTitle, note: ""))
			vc.notesData = self.notes
			vc.indexPath = IndexPath(row: 0, section: 0)
			self.navigationController?.pushViewController(vc, animated: true)
		}))
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
		present(alert, animated: true, completion: nil)
	}
}
