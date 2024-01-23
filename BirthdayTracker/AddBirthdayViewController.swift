//
//  ViewController.swift
//  BirthdayTracker
//
//  Created by Ксения Баскакова on 31.07.2022.
//

import UIKit
import CoreData
import UserNotifications


class AddBirthdayViewController: UIViewController {
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var birthdatePicker: UIDatePicker!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        birthdatePicker.maximumDate = Date()
    }

    @IBAction func saveTapped(_sender: UIBarButtonItem) {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let birthdate = birthdatePicker.date
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newBirthday = Birthday(context: context)
        newBirthday.firstName = firstName
        newBirthday.lastName = lastName
        newBirthday.birthdate = birthdate as Date?
        newBirthday.birthdayId = UUID().uuidString
        
        if let uniqueId = newBirthday.birthdayId {
            print("birthdayId: \(uniqueId) ")
        }
        
        do {
            try context.save()
            let message = "Сегодня \(firstName) \(lastName) празднует день рождения!"
            let content = UNMutableNotificationContent()
            content.body = message
            content.sound = UNNotificationSound.default
            var dateComonents = Calendar.current.dateComponents([.month, .day], from: birthdate)
            dateComonents.hour = 8
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComonents, repeats: true)
            if let identifier = newBirthday.birthdayId {
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
            }
        } catch let error {
            print("Не удалось сохранить из-за ошибки \(error). ")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}

