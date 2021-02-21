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
  private let colors: [UIColor] = [#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)]

  // MARK: - View
  var body: some View {
    VStack {
      Text("The interval is \(time)" )
      Circle()
        .foregroundColor(Color(colors[Int(time) % colors.count]))
        .animation(.default)
      Button("Update") {
        time = 0
        $time.start()
      }
      if let screenshotDate = screenshotDate {
        Text("You took a screenshot at \(screenshotDate)")
      }
    }
    .padding()
    .onAppear { $time.start() }
    .onDisappear { $time.stop() }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
