//
//  PostsRepository.swift
//  Socialcademy
//
//  Created by Maël Colomé on 19/07/2025.
//

import Foundation
import FirebaseFirestore

struct PostsRepository {
	static let postsReference = Firestore.firestore().collection("posts")
	
	static func create(_ post: Post) async throws {
		let documents = postsReference.document(post.id.uuidString)
		try await documents.setData(from: post)
	}
}

private extension DocumentReference {
	func setData<T: Encodable>(from value: T) async throws {
		return try await withCheckedThrowingContinuation { continuation in
			// Method only throws if there’s an encoding error, which indicates a problem with our model.
			// We handled this with a force try, while all other errors are passed to the completion handler.
			try! setData(from: value) { error in
				if let error = error {
					continuation.resume(throwing: error)
					return
				}
				continuation.resume()
			}
		}
	}
}
