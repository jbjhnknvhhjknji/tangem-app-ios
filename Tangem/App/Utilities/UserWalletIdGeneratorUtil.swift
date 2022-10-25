//
//  UserWalletIdGeneratorUtil.swift
//  Tangem
//
//  Created by Andrew Son on 25/10/22.
//  Copyright © 2022 Tangem AG. All rights reserved.
//

import Foundation
import CryptoKit

enum UserWalletIdGeneratorUtil {
    static func generateUserWalletId(from keyHash: Data) -> Data {
        let key = SymmetricKey(data: keyHash)
        let message = Constants.messageForWalletID.data(using: .utf8)!
        let authenticationCode = HMAC<SHA256>.authenticationCode(for: message, using: key)
        
        return Data(authenticationCode)
    }
}
