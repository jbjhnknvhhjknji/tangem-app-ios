//
//  SeedPhraseManager.swift
//  Tangem
//
//  Created by Andrew Son on 10/03/23.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import TangemSdk

class SeedPhraseManager {
    private(set) var mnemonic: Mnemonic?
    var seedPhrase: [String] { mnemonic?.mnemonicComponents ?? [] }

    @discardableResult
    func generateSeedPhrase() throws -> [String] {
        let mnemonic = try Mnemonic(with: .bits128, wordList: .en)
        self.mnemonic = mnemonic
        return mnemonic.mnemonicComponents
    }
}
