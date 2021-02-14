//
//  ContentView.swift
//  CustomDynamicProperties
//
//  Created by Joshua Homann on 2/13/21.
//

import SwiftUI

// MARK: - ContentView
struct ContentView: View {
  // MARK: - Instance
  @Interval(update: 1) private var time: TimeInterval
  @Notify(
    notificationName: UIApplication.userDidTakeScreenshotNotification,
    transform: { _ in Date() }
  ) private var screenshotDate: Date?
  // MARK: - View
  var body: some View {
    VStack {
      Text("The interval is \(time)" )
      Button("Update") {
        time = 0
        _time.start()
      }
      if let screenshotDate = screenshotDate {
        Text("You took a screenshot at \(screenshotDate)")
      }
    }
    .onAppear { _time.start() }
    .onDisappear { _time.stop() }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
