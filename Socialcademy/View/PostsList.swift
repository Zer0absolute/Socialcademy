//
//  PostList.swift
//  Socialcademy
//
//  Created by Maël Colomé on 19/07/2025.
//

import SwiftUI

struct PostsList: View {
	private var posts = [Post.testPost]
	@State private var searchText: String = ""
	
	var filteredPosts: [Post] {
		if searchText.isEmpty {
			return posts
		} else {
			return posts.filter { $0.contains(searchText) }
		}
	}
	
    var body: some View {
		NavigationStack {
			List(filteredPosts) { post in
				PostRow(post: post)
			}
			.overlay {
				if filteredPosts.isEmpty && !searchText.isEmpty {
					ContentUnavailableView.search
				}
			}
			.searchable(text: $searchText, prompt: "Search post")
			.navigationTitle("Posts")
		}
    }
}

#Preview {
    PostsList()
}
