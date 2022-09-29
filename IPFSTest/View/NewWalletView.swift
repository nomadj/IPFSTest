//
//  NewWalletView.swift
//  IPFSTest
//
//  Created by Bryan Albert on 9/18/22.
//

import SwiftUI
import web3swift

struct NewWalletView: View {
    @State var initFunc = false
    @State var isLoading = false
    @State var mnemonicList: [String] = []
    @State var errorAlert = false
    @State var mnemonic = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(mnemonicList, id: \.self) { word in
                    Text(word)
                }
                .padding()
                .font(.headline)
                .opacity(1)
                .shadow(color: .gray, radius: 5)
            }
            
            Button {
                isLoading = true
                initFunc.toggle()
            } label: {
                if isLoading {
                    ProgressView()
                    
                } else {
                    Image(systemName: "ladybug.fill")
                }
            }
            .buttonStyle(MyButtonStyle())
            .disabled(isLoading)
            .onChange(of: initFunc) { _ in
                newHDWallet() { wal, error in
                    print(wal!.address)
                    isLoading = false
                }
            }
            
//                let wallet = self.importHDWallet(seedPhrase: "cheap crisp giant giraffe keep wealth maze ramp distance one teach basic", name: "NeatoWallet", password: "balls")
//                print(wallet.address)
            .alert(isPresented: $errorAlert) {
                Alert(title: Text("URL Error"), message: Text("Are you connected to the internet?"))
            }
        }
    }
    
    /// ***********
    /// ** Methods **
    /// ***********
    
    func newHDWallet(completion: @escaping (Wallet?, Error?) -> Void) {
        /// Setup new wallet with mnemonics
        let queue = OperationQueue()
        queue.addOperation {
            let password = "password"
            let bitsOfEntropy: Int = 128 // Entropy is a measure of password strength. Usually used 128 or 256 bits.
            let mnemonics = try! BIP39.generateMnemonics(bitsOfEntropy: bitsOfEntropy)!
            print(mnemonics)
            let keystore = try! BIP32Keystore(
                mnemonics: mnemonics,
                password: password,
                mnemonicsPassword: "",
                language: .english)!
            let name = "HDWallet"
            let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
            let address = keystore.addresses!.first!.address
            let wallet = Wallet(address: address, data: keyData, name: name, isHD: true, isDefault: true)
            
            completion(wallet, nil)
        }
    }
    
    /// Setup new wallet with private key
//    func newPKWallet(walletName: String, password: String, completion: @escaping (Wallet?, Error?) -> Void) {
//        let keystore = try! EthereumKeystoreV3(password: password)!
//        let name = walletName
//        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
//        let address = keystore.addresses!.first!.address
//        let wallet = Wallet(address: address, data: keyData, name: name, isHD: false, password: password, isDefault: true)
//
////        walletsMaster.append(wallet)
////        do {
////            let encoder = JSONEncoder()
////            // set new wallet as default -- Or not
////            let data = try encoder.encode(wallet)
////            defaults.set(data, forKey: "wallet")
////            let walletsData = try encoder.encode(walletsMaster)
////            defaults.set(walletsData, forKey: "wallets")
////
////        } catch {
////            print("Unable to Encode Wallet (\(error))")
////        }
////         walletsDidChange.toggle()
//    }
    
    func importHDWallet(seedPhrase: String, name: String, password: String) -> Wallet {
        let keystore = try! BIP32Keystore(
            mnemonics: seedPhrase,
            password: password,
            mnemonicsPassword: "",
            language: .english)!
        let name = name
        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
        let address = keystore.addresses!.first!.address
        let wallet = Wallet(address: address, data: keyData, name: name, isHD: true, isDefault: true)
        return wallet
    }
}
