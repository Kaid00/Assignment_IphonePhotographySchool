//
//  ContentView.swift
//  Assignment
//
//  Created by Azamah Junior Khan on 17/01/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LessonList()
            .preferredColorScheme(.dark)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
