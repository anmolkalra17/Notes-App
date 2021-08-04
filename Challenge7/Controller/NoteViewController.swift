//
//  NoteViewController.swift
//  Challenge7
//
//  Created by Anmol Kalra on 02/08/21.
//

import UIKit

class NoteViewController: UIViewController {

	lazy var textView: UITextView = {
		let someTextView = UITextView()
		someTextView.translatesAutoresizingMaskIntoConstraints = false
		someTextView.allowsEditingTextAttributes = true
		someTextView.font = UIFont.systemFont(ofSize: 18)
		return someTextView
	}()
	
	var textViewText: String?
	var notesData = [NoteDataModel]()
	var indexPath: IndexPath?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveNote))
		let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
		let share = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareNote))
		
		navigationItem.rightBarButtonItems = [share, delete]
		
		createTextView()
		registerNotificationsForKeyboard()
    }
	
	func createTextView() {
		view.addSubview(textView)
		NSLayoutConstraint.activate([
			textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
		guard let text = textViewText else { return }
		textView.text = text
	}
	
	//MARK: - Auto scroll notifications for textView
	
	func registerNotificationsForKeyboard() {
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
	}
	
	@objc func adjustForKeyboard(notification: Notification) {
		guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
		let keyboardScreenEndFrame = keyboardValue.cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
		
		if notification.name == UIResponder.keyboardWillHideNotification {
			textView.contentSize = .zero
		} else {
			textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
		}
		
		textView.scrollIndicatorInsets = textView.contentInset
		
		let selectedRange = textView.selectedRange
		textView.scrollRangeToVisible(selectedRange)
	}
	
	//MARK: - Save and delete methods
	
	@objc func saveNote() {
		guard let textToSave = textView.text else { return }
		let noteObject = NoteDataModel(title: self.title!, note: textToSave)
		
		if notesData.isEmpty {
			notesData.insert(noteObject, at: 0)
		} else {
			if notesData[indexPath?.row ?? 0].title == self.title! {
				notesData[indexPath?.row ?? 0].note = textToSave
			} else {
				notesData.insert(noteObject, at: 0)
			}
		}
		
		DataManager.instance.encodeData(using: notesData)
		navigationController?.popViewController(animated: true)
	}
	
	@objc func deleteNote() {
		let alert = UIAlertController(title: "Delete Note?", message: "Are you sure you want to delete this note?", preferredStyle: .alert)
		let yes = UIAlertAction(title: "Yes", style: .destructive) { _ in
			self.notesData.remove(at: self.indexPath!.row)
			DataManager.instance.encodeData(using: self.notesData)
			self.navigationController?.popViewController(animated: true)
		}
		let no = UIAlertAction(title: "No", style: .default, handler: nil)
		alert.addAction(yes)
		alert.addAction(no)
		
		present(alert, animated: true, completion: nil)
	}
	
	@objc func shareNote() {
		
		let noteToShare = notesData[indexPath?.row ?? 0]
		let activityVC = UIActivityViewController(activityItems: ["\(noteToShare.title) \n \(noteToShare.note ?? "")"], applicationActivities: [])
		present(activityVC, animated: true, completion: nil)
	}
}
