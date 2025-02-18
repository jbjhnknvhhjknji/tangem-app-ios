//
//  Analytics+ParameterKey.swift
//  Tangem
//
//  Created by Alexander Osokin on 08.02.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import Foundation

extension Analytics {
    enum ParameterKey: String {
        case blockchain
        case firmware = "Firmware"
        case action
        case errorDescription = "error_description"
        case errorCode = "error_code"
        case newSecOption = "new_security_option"
        case errorKey = "Tangem SDK error key"
        case walletConnectAction = "wallet_connect_action"
        case walletConnectRequest = "wallet_connect_request"
        case walletConnectDappUrl = "wallet_connect_dapp_url"
        case source
        case type
        case currency = "Currency Type" // fiat
        case success
        case token = "Token"
        case derivationPath = "Derivation Path"
        case network = "Network"
        case networkId = "Network Id"
        case contractAddress = "Contract Address"
        case mode = "Mode"
        case state = "State"
        case basicCurrency = "Currency"
        case batch = "Batch"
        case cardsCount = "Cards count"
        case sku = "SKU"
        case amount = "Amount"
        case count = "Count"
        case couponCode = "Coupon Code"
        case productType = "Product Type"
        case sendToken = "Send Token"
        case receiveToken = "Receive Token"
        case commonSource = "Source"
        case commonType = "Type"
        case signInType = "Sign in type"
        case balance = "Balance"
        case creationType = "Creation type"
        case status = "Status"
        case option
        case feeType = "Fee Type"
        case permissionType = "Permission Type"
        case validation = "Validation"
        case memo = "Memo"
        case walletsCount = "Wallets Count"
        case exceptionHost = "exception_host"
        case selectedHost = "selected_host"
        case region
        case clientType = "Client Type"
        case programName = "Program Name"
        case dAppName = "DApp Name"
        case dAppUrl = "DApp Url"
        case methodName = "Method Name"
    }
}
