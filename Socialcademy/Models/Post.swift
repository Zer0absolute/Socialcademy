//
//  Post.swift
//  Socialcademy
//
//  Created by Maël Colomé on 19/07/2025.
//

import Foundation

struct Post: Identifiable, Equatable, Codable {
	var title: String
	var content: String
	var authorName: String
	var isFavorite: Bool
	var timestamp: Date
	var id: UUID
	
	// Initializer par défaut
	init(title: String, content: String, authorName: String, isFavorite: Bool = false, timestamp: Date = Date(), id: UUID = UUID()) {
		self.title = title
		self.content = content
		self.authorName = authorName
		self.isFavorite = isFavorite
		self.timestamp = timestamp
		self.id = id
	}
	
	func contains(_ string: String) -> Bool {
		let properties = [title, content, authorName]
		let query = string.lowercased()
		
		return properties.contains { property in
			property.localizedCaseInsensitiveContains(query)
		}
	}
	
	// Implémentation explicite de Equatable pour comparer isFavorite aussi
	static func == (lhs: Post, rhs: Post) -> Bool {
		return lhs.id == rhs.id && lhs.isFavorite == rhs.isFavorite
	}
}

extension Post {
	static let testPost = Post(
		title: "Lorem ipsum",
		content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
		authorName: "Jamie Harris"
	)
}
