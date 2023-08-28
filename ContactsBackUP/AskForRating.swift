//
//  AskForRating.swift
//  ContactsBackUP
//
//  Created by Yousef Zuriqi on 28/08/2023.
//


import Foundation
import SwiftUI
import StoreKit




class RateTheApp {
    
   
    
    static var shared = RateTheApp()
    
    private init() {}
    
    // check if its in debug mode
    // if it's debug mode the pop will show each time.
    private var isDebuggingEnabled: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    func askForRatingAfterTwoSeconds() {
        let requestWorkItem = DispatchWorkItem {
            self.askForRating()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: requestWorkItem)
    }

    private func askForRating() {
        
        #if os(macOS)
            SKStoreReviewController.requestReview()
        #else
        
            guard let scene = UIApplication.shared.foregroundActiveScene else { return }
            SKStoreReviewController.requestReview(in: scene)
        #endif
    }
}


