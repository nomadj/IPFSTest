//
//  Objects.swift
//  IPFSTest
//
//  Created by Bryan Albert on 9/18/22.
//

import BigInt
import web3swift

struct Contract: Hashable {
    var name: String
    var symbol: String
    var hash: EthereumAddress
}

struct Wallet: Codable, Hashable {
    let address: String
    let data: Data
    let name: String
    let isHD: Bool
    // let password: String
    var isDefault: Bool
}

struct NFT: Codable, Hashable {
    let name: String
    let contract: EthereumAddress
    let roomId: BigUInt
}

struct HDKey {
    let name: String?
    let address: String
}
