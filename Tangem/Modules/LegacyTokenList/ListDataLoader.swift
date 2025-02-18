//
//  ListDataLoader.swift
//  Tangem
//
//  Created by Alexander Osokin on 14.04.2022.
//  Copyright © 2022 Tangem AG. All rights reserved.
//

import SwiftUI
import Combine
import TangemSdk
import BlockchainSdk

class ListDataLoader {
    // MARK: Dependencies

    @Injected(\.tangemApiService) var tangemApiService: TangemApiService

    // MARK: Output

    @Published var items: [CoinModel] = []

    // Tells if all items have been loaded. (Used to hide/show activity spinner)
    private(set) var canFetchMore = true

    // MARK: Input

    private let supportedBlockchains: Set<Blockchain>
    private let exchangeable: Bool?

    // MARK: Private

    // Tracks last page loaded. Used to load next page (current + 1)
    private var currentPage = 0

    // Limit of records per page
    private let perPage = 50

    private var cancellable: AnyCancellable?

    private var cached: [CoinModel] = []
    private var cachedSearch: [String: [CoinModel]] = [:]
    private var lastSearchText = ""

    init(supportedBlockchains: Set<Blockchain>, exchangeable: Bool? = nil) {
        self.supportedBlockchains = supportedBlockchains
        self.exchangeable = exchangeable
    }

    func reset(_ searchText: String) {
        canFetchMore = true
        items = []
        currentPage = 0
        lastSearchText = searchText
        cachedSearch = [:]
    }

    func fetch(_ searchText: String) {
        cancellable = nil

        if lastSearchText != searchText {
            reset(searchText)
        }

        cancellable = loadItems(searchText)
            .receive(on: DispatchQueue.global())
            .sink { [weak self] items in
                guard let self = self else { return }

                currentPage += 1
                self.items.append(contentsOf: items)
                // If count of data received is less than perPage value then it is last page.
                if items.count < perPage {
                    canFetchMore = false
                }
            }
    }
}

// MARK: Private

private extension ListDataLoader {
    func loadItems(_ searchText: String) -> AnyPublisher<[CoinModel], Never> {
        let searchText = searchText.trimmed()
        let requestModel = CoinsList.Request(
            supportedBlockchains: supportedBlockchains,
            searchText: searchText,
            exchangeable: exchangeable,
            limit: perPage,
            offset: items.count,
            active: true
        )

        // If testnet then use local coins from testnet_tokens.json file.
        if supportedBlockchains.contains(where: { $0.isTestnet }) {
            return loadTestnetItems(requestModel)
        }

        return loadMainnetItems(requestModel)
    }

    func loadTestnetItems(_ requestModel: CoinsList.Request) -> AnyPublisher<[CoinModel], Never> {
        let searchText = requestModel.searchText?.lowercased()
        let itemsPublisher: AnyPublisher<[CoinModel], Never>

        if cached.isEmpty {
            itemsPublisher = loadCoinsFromLocalJsonPublisher(requestModel: requestModel)
        } else {
            itemsPublisher = Just(cached).eraseToAnyPublisher()
        }

        return itemsPublisher
            .map { [weak self] models -> [CoinModel] in
                guard let self = self else { return [] }

                guard let searchText = searchText,
                      !searchText.isEmpty else { return models }

                if let cachedSearch = cachedSearch[searchText] {
                    return cachedSearch
                }

                let foundItems = models.filter {
                    "\($0.name) \($0.symbol)".lowercased().contains(searchText)
                }

                cachedSearch[searchText] = foundItems

                return foundItems
            }
            .map { [weak self] models -> [CoinModel] in
                self?.getPage(for: models) ?? []
            }
            .eraseToAnyPublisher()
    }

    func loadMainnetItems(_ requestModel: CoinsList.Request) -> AnyPublisher<[CoinModel], Never> {
        tangemApiService.loadCoins(requestModel: requestModel)
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }

    func loadCoinsFromLocalJsonPublisher(requestModel: CoinsList.Request) -> AnyPublisher<[CoinModel], Never> {
        TestnetTokensRepository().loadCoins(requestModel: requestModel)
            .handleEvents(receiveOutput: { [weak self] output in
                self?.cached = output
            })
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }

    func getPage(for items: [CoinModel]) -> [CoinModel] {
        Array(items.dropFirst(currentPage * perPage).prefix(perPage))
    }
}
