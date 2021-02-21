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
  final class Wrapper: ObservableObject {
    @Published var time: TimeInterval = 0
    private let startSubject = PassthroughSubject<Void, Never>()
    private let stopSubject = PassthroughSubject<Void, Never>()
    init(interval: TimeInterval) {
      startSubject
        .compactMap { [weak self] _ in
          self.map { owner in
            Timer
              .publish(every: interval, on: .main, in: .common)
              .autoconnect()
              .prefix(untilOutputFrom: owner.stopSubject)
              .map { _ in interval }
              .scan(owner.time, +)
              .prepend(0)
          }
        }
        .switchToLatest()
        .assign(to: &$time)
    }
    func start() {
      startSubject.send()
    }
    func stop() {
      stopSubject.send()
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

  var projectedValue: Wrapper {
    wrappedObject
  }
  
  init(update interval: TimeInterval) {
    _wrappedObject = .init(wrappedValue: Wrapper(interval: interval))
  }
}
