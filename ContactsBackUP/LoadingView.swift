//
//  LoadingView.swift
//  ContactsBackUP
//
//  Created by Yousef Zuriqi on 28/08/2023.
//

import SwiftUI


struct LoadingView: View {
    @Binding var progress: Double
    var body: some View {
        ProgressView( value: progress, total: 100)
            .progressViewStyle(LinearProgressViewStyle())
            .scaleEffect(x: 1, y: 4, anchor: .center)
            .padding()
    }
}
