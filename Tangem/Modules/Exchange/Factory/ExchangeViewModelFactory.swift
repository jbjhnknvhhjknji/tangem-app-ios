//
//  ExchangeViewModelFactory.swift
//  Tangem
//
//  Created by Pavel Grechikhin on 09.11.2022.
//  Copyright © 2022 Tangem AG. All rights reserved.
//

import Foundation
import BlockchainSdk

class ExchangeViewModelFactory {
    func createExchangeViewModel(exchangeManager: ExchangeManager,
                                 signer: TangemSigner,
                                 sourceCurrency: Currency,
                                 coinModel: CoinModel,
                                 exchangeRouter: ExchangeFacadeFactory.Router) -> ExchangeViewModel {

        let exchangeFacadeFactory = ExchangeFacadeFactory()
        let tokensFactory = ExchangeTokensFactory(coinModel: coinModel, blockchainNetwork: sourceCurrency.blockchainNetwork)

        var destinationCurrency: Currency!
        if sourceCurrency.isToken {
            destinationCurrency = tokensFactory.createCoin()
        } else {
            destinationCurrency = tokensFactory.createToken(token: .dai)
        }

        let exchangeFacade = exchangeFacadeFactory.createFacade(for: exchangeRouter,
                                                                exchangeManager: exchangeManager,
                                                                signer: signer,
                                                                blockchainNetwork: sourceCurrency.blockchainNetwork)

        return ExchangeViewModel(exchangeFacade: exchangeFacade,
                                 sourceCurrency: sourceCurrency,
                                 destinationCurrency: destinationCurrency)
    }
}
