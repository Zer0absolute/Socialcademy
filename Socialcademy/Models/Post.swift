//
//  Post.swift
//  Socialcademy
//
//  Created by Maël Colomé on 19/07/2025.
//

import Foundation

struct Post: Identifiable, Codable {
	var title: String
	var content: String
	var authorName: String
	var timestamp = Date()
	var id = UUID()
	
	func contains(_ string: String) -> Bool {
		let properties = [title, content, authorName]
		let query = string.lowercased()
		
		return properties.contains { property in
			property.localizedCaseInsensitiveContains(query)
		}
	}
	
}

extension Post {
	static let testPost = Post(
		title: "Lorem ipsum",
		content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
		authorName: "Jamie Harris"
	)
}
