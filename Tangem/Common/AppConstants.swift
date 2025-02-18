//
//  Constants.swift
//  Tangem
//
//  Created by Andrew Son on 13/05/21.
//  Copyright © 2021 Tangem AG. All rights reserved.
//

import Foundation
import UIKit

enum AppConstants {
    static let tangemDomainUrl = URL(string: "https://tangem.com")!

    static var isSmallScreen: Bool {
        UIScreen.main.bounds.width < 375 || UIScreen.main.bounds.height < 650
    }

    static let messageForWalletID = "UserWalletID"
    static let messageForTokensKey = "TokensSymmetricKey"
    static let maximumFractionDigitsForBalance = 8

    static let defaultScrollViewKeyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
}
