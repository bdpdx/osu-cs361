//
//  CircleImage.swift
//  Client
//
//  Created by Brian Doyle on 1/5/22.
//

import SwiftUI

struct CircleImage: View {
    @EnvironmentObject var model: Model

    var body: some View {
        model.image
            .resizable()
            .background(Color.white)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.black, lineWidth: 4)
            }
            .scaledToFit()
            .shadow(radius: 7)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
