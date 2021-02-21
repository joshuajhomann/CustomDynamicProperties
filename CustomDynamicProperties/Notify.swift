//
//  Notify.swift
//  CustomDynamicProperties
//
//  Created by Joshua Homann on 2/13/21.
//

import Combine
import Foundation
import SwiftUI

@propertyWrapper
struct Notify<Value>: DynamicProperty {
  private final class Wrapper: ObservableObject {
    @Published var value: Value? = nil
    private let transform: (Notification) -> Value
    init(notificationName: Notification.Name, transform: @escaping (Notification) -> Value) {
      self.transform = transform
      NotificationCenter
        .default
        .publisher(for: notificationName)
        .map(transform)
        .assign(to: &$value)
    }
  }
  @StateObject private var wrapped: Wrapper
  var wrappedValue: Value? {
    get { wrapped.value }
    nonmutating set { wrapped.value = newValue }
  }

  init(notificationName: Notification.Name, transform: @escaping (Notification) -> Value ) {
    self._wrapped = .init(wrappedValue:
      Wrapper(
        notificationName: notificationName,
        transform: transform
      )
    )
  }
}
