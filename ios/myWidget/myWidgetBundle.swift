//
//  myWidgetBundle.swift
//  myWidget
//
//  Created by Guillermo Guevara on 31-03-25.
//

import WidgetKit
import SwiftUI

@main
struct myWidgetBundle: WidgetBundle {
    var body: some Widget {
        myWidget()
        myWidgetControl()
        myWidgetLiveActivity()
    }
}
