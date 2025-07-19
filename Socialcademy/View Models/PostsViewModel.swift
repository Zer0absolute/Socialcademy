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
	var posts = [Post.testPost]
	
	func makeCreateAction() -> NewPostForm.CreateAction {
		return { [weak self] post in
			try await PostsRepository.create(post)
			self?.posts.insert(post, at: 0)
		}
	}
}
