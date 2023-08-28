//
//  Extension++UIApplication.swift
//  Help Me Talk
//
//  Created by Yousef Zuriqi on 20/12/2022.
//  Copyright © 2022 yousef zuriqi. All rights reserved.
//

import SwiftUI

extension UIApplication {
    var foregroundActiveScene: UIWindowScene? {
        connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    }
}
