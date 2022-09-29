//
//  DebugView.swift
//  IPFSTest
//
//  Created by Bryan Albert on 9/18/22.
//

import SwiftUI
import web3swift

struct DebugView: View {
    @State var triggerDownloader = false
    @State var isLoading = false
    @State var mnemonic: [String] = []
    
    var body: some View {
        VStack {
            List {
                ForEach(mnemonic, id: \.self) { word in
                    Text(word)
                }
            }
            Button {
                triggerDownloader.toggle()
                isLoading = true
            } label: {
                if !isLoading { Image(systemName: "ladybug.fill") } else { ProgressView() }
            }
            .buttonStyle(MyButtonStyle())
            .onChange(of: triggerDownloader) { _ in
                urlRequest(urlString: "https://eips.ethereum.org/assets/eip-3450/wordlist.txt") { res, error in
                    if let error = error {
                        print(error)
                    } else {
                        generateMnemonic(wordList: res as! String)
                    }
                }
            }
        }
    }
    
    /// ***********
    /// ** Methods **
    /// ***********

    func urlRequest(urlString: String, completion: @escaping (Any?, Error?) -> Void) {
        let url = URL(string: urlString)
        let task = URLSession.shared.downloadTask(with: url!) { localURL, urlResponse, error in
            if let localURL = localURL {
                if let string = try? String(contentsOf: localURL) {
                    completion(string, nil)
                }
            }

        }
        task.resume()
        isLoading = false
    }
    
    func generateMnemonic(wordList: String) {
        mnemonic.removeAll()
        var mnemonics = wordList.components(separatedBy: "\n")
        if mnemonics.count == 2049 {
            mnemonics.remove(at: 2048)
        }
        for _ in 0..<12 {
            mnemonic.append(mnemonics[Int.random(in: 0..<mnemonics.count)])
        }
    }
}
