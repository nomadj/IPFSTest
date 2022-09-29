//
//  ContentView.swift
//  IPFSTest
//
//  Created by Bryan Albert on 8/28/22.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .keylist
    
    enum Tab {
        case home
        case nftList
        case keylist
        case debug
        case scratch
        case mint
    }
    var body: some View {
        TabView(selection: $selection) {
//            HomeView()
//                .tabItem {
//                    Label("Home", systemImage: "house.fill")
//                }
//                .tag(Tab.home)
            MintView()
                .tabItem {
                    Label("Mint", systemImage: "coloncurrencysign.circle.fill")
                }
                .tag(Tab.mint)
            
            NewWalletView()
                .tabItem {
                    Label("Debug", systemImage: "ladybug.fill")
                }
                .tag(Tab.debug)
            
//            SubmitView()
//                .tabItem {
//                    Label("Submit", systemImage: "video.fill.badge.plus")
//                }
//                .tag(Tab.submit)
//            
//            Scratch()
//                .tabItem {
//                    Label("Scratch", systemImage: "lungs.fill")
//                }
//                .tag(Tab.scratch)
        }
        .accentColor(Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)))
    }
}

