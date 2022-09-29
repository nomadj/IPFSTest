//
//  settings.swift
//  IPFSTest
//
//  Created by Bryan Albert on 9/18/22.
//

import SwiftUI
import BigInt
import web3swift

let defaults = UserDefaults.standard

let factoryAddress = EthereumAddress("0x6996fe8fd3a5ddd9abe0e500c9b064c4e4e5b396")!
let factoryAddressGoerli = EthereumAddress("0xA55D2785e5CcDF126fEFF311c96958b45F2eF72a")!
let infuraGoerli = "https://goerli.infura.io/v3/7f709d402b7e4ec59b7c771c3da42204"
let infuraMainnet = "https://mainnet.infura.io/v3/7f709d402b7e4ec59b7c771c3da42204"
let w3 = web3(provider: Web3HttpProvider(URL(string: infuraMainnet)!)!)
let w3g = web3(provider: Web3HttpProvider(URL(string: infuraGoerli)!)!)
let factoryContract = w3.contract(factoryABI, at: factoryAddress, abiVersion: 2)!
let factoryContractGoerli = w3.contract(factoryABI, at: factoryAddressGoerli, abiVersion: 2)!
// let wallet = getWallet() as! Wallet

func initCanClick() {
    defaults.set(true, forKey: "canClick")
    defaults.set(false, forKey: "isTransacting")
}

func setPublicKey(key: String) -> String {
    defaults.set(key, forKey: "publicKey")
    if var accounts = defaults.object(forKey: "accounts") as? [String] {
        accounts.append(key)
        defaults.set(accounts, forKey: "accounts")
        print(defaults.object(forKey: "accounts")!)
    } else {
        var accounts: [String] = []
        accounts.append(key)
        defaults.set(accounts, forKey: "accounts")
    }
        
    return defaults.string(forKey: "publicKey")!
}

//func walletSetup() -> Any {
//    if let data = UserDefaults.standard.data(forKey: "wallet") {
//        print("Wallet already set")
//        do {
//            // Create JSON Decoder
//            let decoder = JSONDecoder()
//
//            // Decode Wallet
//            let wallet = try decoder.decode(Wallet.self, from: data)
//            print(wallet.address)
//            return wallet
//
//        } catch {
//            print("Unable to Decode Wallet (\(error))")
//        }
//    } else {
//        // Setup new wallet
//        print("Setting new wallet")
//        let password = "password"
//        defaults.set(password, forKey: "password")
//        let keystore = try! EthereumKeystoreV3(password: password)!
//        let name = "New Wallet"
//        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
//        let address = keystore.addresses!.first!.address
//        let wallet = Wallet(address: address, data: keyData, name: name, isHD: false, isDefault: true)
//        do {
//            let encoder = JSONEncoder()
//
//            // Encode Wallet
//            let data = try encoder.encode(wallet)
//            defaults.set(data, forKey: "wallet")
//
//        } catch {
//            print("Unable to Encode Wallet (\(error))")
//        }
//        return wallet
////        if let data = UserDefaults.standard.data(forKey: "wallet") {
////            do {
////                // Create JSON Decoder
////                let decoder = JSONDecoder()
////
////                // Decode Note
////                let wallet = try decoder.decode(Wallet.self, from: data)
////                print(wallet.address)
////
////            } catch {
////                print("Unable to Decode Wallet (\(error))")
////            }
////        }
//    }
//    return 1
//}

func setInfuraId() {
    defaults.set("7f709d402b7e4ec59b7c771c3da42204", forKey: "infuraKey")
    print(defaults.string(forKey: "infuraKey")!)
}

