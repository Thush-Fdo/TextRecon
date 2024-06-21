//
//  UIViewController+Ext.swift
//  TextRecon
//
//  Created by Thush_Fdo on 21/06/2024.
//

import UIKit

extension UIViewController {
    
    func presentGRAlertOnMainThread(title: String, message: String, buttonTitle: String){
        DispatchQueue.main.async {
            let alertVC = TRAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}
