//
//  Utilities.swift
//  IPFSTest
//
//  Created by Bryan Albert on 9/18/22.
//

import Foundation
import web3swift

func initWallets() -> Any {
    if let data = defaults.object(forKey: "wallet") as? Data {
        do {
        let decoder = JSONDecoder()
        let wallet = try decoder.decode(Wallet.self, from: data)
        return wallet
        } catch {
            print("Error decoding wallet")
        }
    } else {
        // newWallet()
    }
    return 1
}

func urlRequest(urlString: String, completion: @escaping (Any?, Error?) -> Void) {
    let url = URL(string: urlString)
    let task = URLSession.shared.downloadTask(with: url!) { localURL, urlResponse, error in
        if let localURL = localURL {
            if let string = try? String(contentsOf: localURL) {
                completion(string, nil)
            }
        }
        else {
            print("Are you connected to the internet?")
        }
    }
    task.resume()
}
