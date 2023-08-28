//
//  LottieView.swift
//  ContactsBackUP
//
//  Created by Yousef Zuriqi on 28/08/2023.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let animationView = LottieAnimationView()
    var name: String
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        animationView.animation = LottieAnimation.named(name)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .repeat(2)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        animationView.play()
    }
}

