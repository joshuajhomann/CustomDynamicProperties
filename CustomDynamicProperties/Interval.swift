//
//  Interval.swift
//  CustomDynamicProperties
//
//  Created by Joshua Homann on 2/13/21.
//

import Combine
import Foundation
import SwiftUI

@propertyWrapper
struct Interval: DynamicProperty {
  private final class Wrapper: ObservableObject {
    @Published var time: TimeInterval = 0
    let startSubject = PassthroughSubject<Void, Never>()
    let stopSubject = PassthroughSubject<Void, Never>()
    init(interval: TimeInterval) {
      startSubject
        .compactMap { [weak self] _ in
          self.map { owner in
            Timer
              .publish(every: interval, on: .main, in: .common)
              .autoconnect()
              .prefix(untilOutputFrom: owner.stopSubject)
              .map { _ in owner.time + 1 }
              .prepend(0)
          }
        }
        .switchToLatest()
        .assign(to: &$time)
    }
  }
  @StateObject private var wrappedObject: Wrapper

  var wrappedValue: TimeInterval {
    get {
      wrappedObject.time
    }
    nonmutating set {
      wrappedObject.time = newValue
    }
  }
  init(update interval: TimeInterval) {
    _wrappedObject = .init(wrappedValue: Wrapper(interval: interval))
  }
  func start() {
    wrappedObject.startSubject.send()
  }
  func stop() {
    wrappedObject.stopSubject.send()
  }
}
