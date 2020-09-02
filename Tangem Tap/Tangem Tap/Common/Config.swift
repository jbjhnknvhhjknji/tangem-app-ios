//
//  Config.swift
//  Tangem Tap
//
//  Created by Alexander Osokin on 01.09.2020.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation

struct Config {
    var coinMarketCapApiKey: String {
        raw[Config.Keys.coinMarketCapApiKey.rawValue] as! String
    }
    
    private enum Keys: String {
        case coinMarketCapApiKey
    }
    
    let raw: [String: Any]
    
    init() {
        let path = Bundle.main.path(forResource: "Config", ofType: "plist")!
        raw =  NSDictionary(contentsOfFile: path) as! Dictionary
    }
}
