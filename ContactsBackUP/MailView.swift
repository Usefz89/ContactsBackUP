//
//  MailView.swift
//  ContactsBackUP
//
//  Created by Yousef Zuriqi on 28/08/2023.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    var vcfFileURL: URL
    var completionHandler: () -> ()
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        var completionHandler: () -> ()
        
        init(  completionHandler: @escaping () -> ()) {
            self.completionHandler = completionHandler
        }
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
            switch result {
            case .cancelled:
                break
            case .sent:
                completionHandler()

            case .saved:
                break
            case .failed:
                break
            @unknown default:
                break
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(completionHandler: self.completionHandler)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        if MFMailComposeViewController.canSendMail() {
            let mailController = MFMailComposeViewController()
            mailController.mailComposeDelegate = context.coordinator
            mailController.setSubject("My Contacts Backup")
            mailController.setMessageBody("Please find attached the backup of my contacts.", isHTML: false)
            
            if let data = try? Data(contentsOf: vcfFileURL) {
                mailController.addAttachmentData(data, mimeType: "text/x-vcard", fileName: "contacts.vcf")
            }
            
            return mailController
        } else {
            // If the device cannot send mails, return a generic UIViewController
            return UIAlertController(title: "Mail App not configured", message: "Please install or reconfigure you Mail app in order to send emails", preferredStyle: .actionSheet)
        }
    }


    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // No update code needed
    }
}
