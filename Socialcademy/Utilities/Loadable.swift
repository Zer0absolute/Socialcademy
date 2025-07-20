//
//  Loadable.swift
//  Socialcademy
//
//  Created by Maël Colomé on 20/07/2025.

import Foundation
//

enum Loadable<T> {
	case loading
	case loaded(T)
	case error(Error)
}

extension Loadable where T: RangeReplaceableCollection {
	static var empty: Loadable<T> { .loaded(T()) }
}

extension Loadable: Equatable where T: Equatable {
	static func == (lhs: Loadable<T>, rhs: Loadable<T>) -> Bool {
		switch (lhs, rhs) {
		case (.loading, .loading):
			return true
		case let (.error(error1), .error(error2)):
			return error1.localizedDescription == error2.localizedDescription
		case let (.loaded(value1), .loaded(value2)):
			return value1 == value2
		default:
			return false
		}
	}
}

extension Loadable {
	var value: T? {
		get {
			if case let .loaded(value) = self {
				return value
			}
			return nil
		}
	}

	mutating func setValue(_ newValue: T?) {
		guard let newValue = newValue else { return }
		self = .loaded(newValue)
	}
}

extension Loadable {
	func simulate() async throws -> T {
		switch self {
		case .loading:
			try await Task.sleep(nanoseconds: 10 * 1_000_000_000)
			fatalError("Timeout exceeded for “loading” case preview")
		case let .error(error):
			throw error
		case let .loaded(value):
			return value
		}
	}

	/// Preview-only error case for testing UI
	static var previewError: Loadable<T> { .error(PreviewError()) }

	private struct PreviewError: LocalizedError {
		let errorDescription: String? = "Lorem ipsum dolor sit amet."
	}
}
