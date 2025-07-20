//
//  PostsRepository.swift
//  Socialcademy
//
//  Created by Maël Colomé on 19/07/2025.
//

import Foundation
import FirebaseFirestore

protocol PostsRepositoryProtocol {
	func fetchPosts() async throws -> [Post]
	func create(_ post: Post) async throws
	func delete(_ post: Post) async throws
	func favorite(_ post: Post) async throws
	func unfavorite(_ post: Post) async throws
}

struct PostsRepository: PostsRepositoryProtocol {
	let postsReference = Firestore.firestore().collection("posts_v1")
	
	func create(_ post: Post) async throws {
		let document = postsReference.document(post.id.uuidString)
		try await document.setData(from: post)
	}
	
	func delete(_ post: Post) async throws {
		let document = postsReference.document(post.id.uuidString)
		try await document.delete()
	}
	
	func favorite(_ post: Post) async throws {
		let document = postsReference.document(post.id.uuidString)
		try await document.setData(["isFavorite": true], merge: true)
	}
	
	func unfavorite(_ post: Post) async throws {
		let document = postsReference.document(post.id.uuidString)
		try await document.setData(["isFavorite": false], merge: true)
	}

	
	func fetchPosts() async throws -> [Post] {
		let snapshot = try await postsReference
			.order(by: "timestamp", descending: true)
			.getDocuments()
		
		return try snapshot.documents.compactMap { document in
			try document.data(as: Post.self)
		}
	}
}

private extension DocumentReference {
	func setData<T: Encodable>(from value: T) async throws {
		return try await withCheckedThrowingContinuation { continuation in
			do {
				try setData(from: value) { error in
					if let error = error {
						continuation.resume(throwing: error)
					} else {
						continuation.resume()
					}
				}
			} catch {
				continuation.resume(throwing: error)
			}
		}
	}
}

#if DEBUG
struct PostsRepositoryStub: PostsRepositoryProtocol {
	let state: Loadable<[Post]>
	
	func fetchPosts() async throws -> [Post] {
		return try await state.simulate()
	}
	
	func create(_ post: Post) async throws {}
	
	func delete(_ post: Post) async throws {}
	
	func favorite(_ post: Post) async throws {}
	
	func unfavorite(_ post: Post) async throws {}
}
#endif
