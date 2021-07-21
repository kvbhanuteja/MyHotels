//
//  AddHotelsViewController.swift
//  MyHotels
//
//  Created by Ajay Gupta on 21/07/21.
//

import UIKit

enum ActionType {
    case add
    case edit
}

var hotelsCount = 0

class AddHotelsViewController: BaseClassViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var hotelNameTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var costTF: UITextField!
    @IBOutlet weak var stayTF: UITextField!
    @IBOutlet weak var oneStar: UIButton!
    @IBOutlet weak var twoStar: UIButton!
    @IBOutlet weak var threeStar: UIButton!
    @IBOutlet weak var fourStar: UIButton!
    @IBOutlet weak var fiveStar: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var actionType: ActionType = .add
    var hotelObject: HotelDetails?
    var hotelDataUpdateDelegate: HotelDataUpdateDelegate?
    var buttons = [UIButton]()
    var rating = 0
    var selectedRow = 0
    let imagePicker = UIImagePickerController()
    var selectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        setUpDatePicker()
        buttons = [oneStar,
                   twoStar,
                   threeStar,
                   fourStar,
                   fiveStar]
        if actionType == .edit {
            if let data = hotelObject {
                self.setupView(data: data)
            } else {
                self.showAlert(title: Constants.errorTitle, message: Constants.message) { _ in
                    self.navigationController?.popToRootViewController(animated: false)
                }
            }
        }
        self.imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewAction))
        tap.numberOfTapsRequired = 1
        self.imageView.addGestureRecognizer(tap)
        self.addActionToButtons(buttons: buttons)
    }
    
    func setUpDatePicker() {
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        self.stayTF.inputView = datePicker
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: #selector(handleDatePicker))
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.stayTF.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel() {
        self.stayTF.resignFirstResponder()
        }
    
    func setupView(data: HotelDetails) {
        self.hotelNameTF.text = data.name
        self.addressTF.text = data.address
        self.rating = data.rating
        self.stayTF.text = getDate(date: data.dateOfStay)
        self.setUpRating()
        imageView.contentMode = .scaleToFill
        self.costTF.text = "\(data.roomRate)"
        self.imageView.image = data.photo
    }
    
    @IBAction func saveDate(sender: UIButton) {
        if self.checkIfValid() {
            if actionType == .edit, var obj = self.hotelObject {
                obj.name = self.hotelNameTF.text ?? ""
                obj.address = self.addressTF.text ?? ""
                obj.rating = self.rating
                obj.dateOfStay = self.selectedDate ?? Date()
                obj.roomRate = Double(self.costTF.text ?? "0") ?? 0
                obj.photo = self.imageView.image ?? UIImage(named: Constants.Images.upload)!
                self.hotelDataUpdateDelegate?.updateTheData(obj: obj, rowIndex: selectedRow)
            } else {
                self.addNewDetails()
            }
            self.navigationController?.popToRootViewController(animated: false)
        } else {
            self.showAlert(title: Constants.errorTitle, message: "Please fill all details")
        }
    }

    @objc func starButtonAction(sender: UIButton) {
        removeRating(buttons: buttons)
        self.rating = sender.tag
        setUpRating()
    }
    
    @objc func imageViewAction() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleDatePicker() {
        if let datePicker = self.stayTF.inputView as? UIDatePicker {
            self.selectedDate = datePicker.date
            self.stayTF.text = getDate(date: self.selectedDate ?? Date())
        }
        self.stayTF.resignFirstResponder()
    }
    
    func setUpRating() {
        for i in 0..<self.rating {
            self.buttons[i].addRating()
        }
    }
}

extension AddHotelsViewController {
    func addActionToButtons(buttons: [UIButton]) {
        buttons.forEach { button in
            button.tintColor = UIColor(named: Constants.Colors.textColor)
            button.addTarget(self, action: #selector(starButtonAction(sender:)), for: .touchUpInside)
        }
    }
    
    func removeRating(buttons: [UIButton]) {
        buttons.forEach { button in
            button.setImage(UIImage(systemName: Constants.Images.emptyStar), for: .normal)
        }
    }
    
    func addNewDetails() {
        hotelsCount += 1
        let obj = HotelDetails(id: hotelsCount,
                               name: self.hotelNameTF.text ?? "",
                               address: self.addressTF.text ?? "",
                               dateOfStay: Date(),
                               roomRate: Double(self.costTF.text ?? "0") ?? 0,
                               rating: self.rating,
                               photo: self.imageView.image ?? UIImage(named: Constants.Images.upload)!)
        self.hotelDataUpdateDelegate?.addData(obj: obj)
    }
    
    func checkIfValid() -> Bool {
        return  !(self.hotelNameTF.text?.isEmpty ?? false) &&
            !(self.addressTF.text?.isEmpty ?? false) &&
            !(self.selectedDate == nil) &&
            !(self.rating <= 0) &&
            !(self.imageView.image == nil)
    }
    
    func getDate(date:Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        return dateformatter.string(from: date)
    }
}

// MARK: - UIImagePickerControllerDelegate methods
extension AddHotelsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleToFill
            imageView.image = pickedImage
        }

        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
