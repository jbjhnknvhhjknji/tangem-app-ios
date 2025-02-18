//
//  KeysManager.swift
//  Tangem
//
//  Created by Andrew Son on 07/12/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation
import BlockchainSdk

class CommonKeysManager {
    private let keys: Keys

    init() throws {
        keys = try JsonUtils.readBundleFile(with: AppEnvironment.current.configFileName, type: CommonKeysManager.Keys.self)
    }
}

extension CommonKeysManager: KeysManager {
    var appsFlyer: AppsFlyerConfig {
        keys.appsFlyer
    }

    var moonPayKeys: MoonPayKeys {
        MoonPayKeys(apiKey: keys.moonPayApiKey, secretApiKey: keys.moonPayApiSecretKey)
    }

    var mercuryoWidgetId: String {
        keys.mercuryoWidgetId
    }

    var mercuryoSecret: String {
        keys.mercuryoSecret
    }

    var blockchainConfig: BlockchainSdkConfig {
        BlockchainSdkConfig(
            blockchairApiKeys: keys.blockchairApiKeys,
            blockcypherTokens: keys.blockcypherTokens,
            infuraProjectId: keys.infuraProjectId,
            nowNodesApiKey: keys.nowNodesApiKey,
            getBlockApiKey: keys.getBlockApiKey,
            kaspaSecondaryApiUrl: keys.kaspaSecondaryApiUrl,
            tronGridApiKey: keys.tronGridApiKey,
            tonCenterApiKeys: .init(mainnetApiKey: keys.tonCenterApiKey.mainnet, testnetApiKey: keys.tonCenterApiKey.testnet),
            fireAcademyApiKeys: .init(mainnetApiKey: keys.chiaFireAcademyApiKey, testnetApiKey: keys.chiaFireAcademyApiKey),
            // TODO: rename to solana
            quickNodeSolanaCredentials: .init(apiKey: keys.quiknodeApiKey, subdomain: keys.quiknodeSubdomain),
            quickNodeBscCredentials: .init(apiKey: keys.bscQuiknodeApiKey, subdomain: keys.bscQuiknodeSubdomain),
            blockscoutCredentials: .init(login: "", password: ""), // used for saltpay tx history
            defaultNetworkProviderConfiguration: .init(logger: .verbose, urlSessionConfiguration: .standart),
            networkProviderConfigurations: [:]
        )
    }

    var shopifyShop: ShopifyShop {
        keys.shopifyShop
    }

    var tangemComAuthorization: String? {
        keys.tangemComAuthorization
    }

    var zendesk: ZendeskConfig {
        keys.zendesk
    }

    var amplitudeApiKey: String {
        keys.amplitudeApiKey
    }

    var utorgSID: String {
        "tangemTEST"
    }

    var infuraProjectId: String {
        keys.infuraProjectId
    }

    var swapReferrerAccount: SwapReferrerAccount? {
        keys.swapReferrerAccount
    }

    var walletConnectProjectId: String {
        keys.walletConnectProjectId
    }
}

extension CommonKeysManager {
    struct Keys: Decodable {
        let moonPayApiKey: String
        let moonPayApiSecretKey: String
        let mercuryoWidgetId: String
        let mercuryoSecret: String
        let blockchairApiKeys: [String]
        let blockcypherTokens: [String]
        let infuraProjectId: String
        let nowNodesApiKey: String
        let getBlockApiKey: String
        let kaspaSecondaryApiUrl: String
        let tonCenterApiKey: TonCenterApiKeys
        let chiaFireAcademyApiKey: String
        let appsFlyer: AppsFlyerConfig
        let amplitudeApiKey: String
        let tronGridApiKey: String
        let quiknodeApiKey: String
        let quiknodeSubdomain: String
        let bscQuiknodeApiKey: String
        let bscQuiknodeSubdomain: String
        let shopifyShop: ShopifyShop
        let tangemComAuthorization: String?
        let zendesk: ZendeskConfig
        let swapReferrerAccount: SwapReferrerAccount?
        let walletConnectProjectId: String
    }
}
