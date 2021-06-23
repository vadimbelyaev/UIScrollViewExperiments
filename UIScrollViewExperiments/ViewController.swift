//
//  ViewController.swift
//  UIScrollViewExperiments
//
//  Created by Vadim Belyaev on 23.06.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var textFields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        subscribeToKeyboardNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func handleTap(_ sender: UIGestureRecognizer) {
        guard sender.state == .ended else {
            return
        }
        for textField in textFields {
            if textField.isFirstResponder {
                textField.resignFirstResponder()
                break
            }
        }
    }
    
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }
        print("Inset was = \(scrollView.contentInset), offset was = \(scrollView.contentOffset)")

        let keyboardHeight = keyboardFrame.cgRectValue.height
        scrollView.contentInset.bottom = keyboardHeight
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("Inset is now = \(self.scrollView.contentInset), offset is now = \(self.scrollView.contentOffset)")
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
    }
    @IBAction func toggleInsetButtonTapped(_ sender: Any) {
        if scrollView.contentInset.bottom == 0 {
            scrollView.contentInset.bottom = 336.0
        } else {
            scrollView.contentInset.bottom = 0
        }
    }
}

