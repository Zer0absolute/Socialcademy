//
//  PostsViewModel.swift
//  Socialcademy
//
//  Created by Maël Colomé on 19/07/2025.
//

import Foundation

@MainActor
@Observable
class PostsViewModel {
	var posts: Loadable<[Post]> = .loading
	private let postsRepository: PostsRepositoryProtocol
	
	init(postsRepository: PostsRepositoryProtocol = PostsRepository()) {
		self.postsRepository = postsRepository
	}
	
	func fetchPosts() {
		Task {
			do {
				posts = .loaded(try await postsRepository.fetchPosts())
			} catch {
				print("[PostsViewModel] Cannot fetch posts: \(error)")
				posts = .error(error)
			}
		}
	}
	
	func makeCreateAction() -> NewPostForm.CreateAction {
		return { [weak self] post in
			try await self?.postsRepository.create(post)

			guard let self = self else { return }

			// Vérifie si posts est déjà en état .loaded
			if case var .loaded(currentPosts) = self.posts {
				currentPosts.insert(post, at: 0)
				self.posts = .loaded(currentPosts)
			}
		}
	}
}
