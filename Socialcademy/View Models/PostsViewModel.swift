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
	private var postRowViewModels: [UUID: PostRowViewModel] = [:]
	
	init(postsRepository: PostsRepositoryProtocol = PostsRepository()) {
		self.postsRepository = postsRepository
	}
	
	func fetchPosts() {
		Task {
			do {
				let fetchedPosts = try await postsRepository.fetchPosts()
				posts = .loaded(fetchedPosts)
				
				// Mettre à jour tous les ViewModels existants avec les nouvelles données
				for post in fetchedPosts {
					if let existingViewModel = postRowViewModels[post.id] {
						existingViewModel.updatePost(post)
					}
				}
			} catch {
				posts = .error(error)
			}
		}
	}
	
	func makeCreateAction() -> NewPostForm.CreateAction {
		return { [weak self] post in
			try await self?.postsRepository.create(post)

			guard let self = self else { return }

			if case var .loaded(currentPosts) = self.posts {
				currentPosts.insert(post, at: 0)
				self.posts = .loaded(currentPosts)
			}
		}
	}
	
	
	func makePostRowViewModel(for post: Post) -> PostRowViewModel {
		// Vérifier si on a déjà un ViewModel pour ce post
		if let existingViewModel = postRowViewModels[post.id] {
			existingViewModel.updatePost(post)
			return existingViewModel
		}
		
		let viewModel = PostRowViewModel(
			post: post,
			deleteAction: { [weak self] in
				guard let self = self else { return }
				
				// Trouver le post actuel dans la liste
				guard case var .loaded(currentPosts) = self.posts,
					  let index = currentPosts.firstIndex(where: { $0.id == post.id }) else {
					return
				}
				
				let postToDelete = currentPosts[index]
				try await self.postsRepository.delete(postToDelete)
				
				// Supprimer de la liste
				currentPosts.remove(at: index)
				self.posts = .loaded(currentPosts)
				
				// Supprimer le ViewModel de la cache
				self.postRowViewModels.removeValue(forKey: post.id)
			},
			favoriteAction: { [weak self] in
				guard let self = self else { return }

				// Trouver le post actuel dans la liste
				guard case var .loaded(currentPosts) = self.posts,
					  let index = currentPosts.firstIndex(where: { $0.id == post.id }) else {
					return
				}
				
				let currentPost = currentPosts[index]
				let newValue = !currentPost.isFavorite

				if newValue {
					try await self.postsRepository.favorite(currentPost)
				} else {
					try await self.postsRepository.unfavorite(currentPost)
				}

				// Recharger les posts depuis Firebase pour s'assurer de la synchronisation
				self.fetchPosts()
			}
		)
		
		// Stocker le ViewModel dans la cache
		postRowViewModels[post.id] = viewModel
		return viewModel
	}
}
