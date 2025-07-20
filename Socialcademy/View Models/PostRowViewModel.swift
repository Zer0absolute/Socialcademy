//
//  PostRowViewModel.swift
//  Socialcademy
//
//  Created by Maël Colomé on 20/07/2025.
//

import Foundation

@MainActor
@Observable
class PostRowViewModel {
	typealias Action = () async throws -> Void

	var post: Post

	private let deleteAction: Action
	private let favoriteAction: Action

	init(post: Post, deleteAction: @escaping Action, favoriteAction: @escaping Action) {
		self.post = post
		self.deleteAction = deleteAction
		self.favoriteAction = favoriteAction
	}

	func deletePost() {
		Task {
			try? await deleteAction()
		}
	}

	func favoritePost() {
		Task {
			try? await favoriteAction()
		}
	}
	
	// Mettre à jour le post quand il change dans le repository
	func updatePost(_ newPost: Post) {
		// Vérifier si le post a vraiment changé pour éviter les mises à jour inutiles
		if self.post != newPost {
			self.post = newPost
		}
	}
}
