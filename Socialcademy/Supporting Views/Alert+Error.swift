//
//  Alert+Error.swift
//  Socialcademy
//
//  Created by Maël Colomé on 20/07/2025.
//

import SwiftUI

private struct ErrorAlertViewModifier: ViewModifier {
	let title: String
	@Binding var error: Error?
	
	func body(content: Content) -> some View {
		content
			.alert(title, isPresented: $error.hasValue, presenting: error, actions: { _ in }) { error in
				Text(error.localizedDescription)
			}
	}
}

private extension Optional {
	var hasValue: Bool {
		get { self != nil }
		set { self = newValue ? self : nil }
	}
}

extension View {
	func alert(_ title: String, error: Binding<Error?>) -> some View {
		modifier(ErrorAlertViewModifier(title: title, error: error))
	}
}
