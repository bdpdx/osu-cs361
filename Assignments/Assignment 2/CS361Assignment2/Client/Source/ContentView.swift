//
//  ContentView.swift
//  Client
//
//  Created by Brian Doyle on 1/5/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: Model

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                CircleImage()
                    .frame(width: 120, height: 120, alignment: .center)
                Spacer()
            }

            Spacer()
                .frame(height: 20)

            Button {
                model.runRandomNumberService()
            } label: {
                Text("Catch Em!")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .frame(minWidth: 110, minHeight: 28)
            }
            .background(.yellow)
            .buttonStyle(.plain)
            .cornerRadius(20)
            .shadow(radius: 4)

            Spacer()
        }
        .background(.gray)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
