//
//  ContentView.swift
//  Tally Counter
//
//  Created by  Vladyslav Fil on 29.09.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            CounterView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.screenBackground.edgesIgnoringSafeArea(.vertical))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
