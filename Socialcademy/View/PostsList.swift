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
	
    var body: some View {
		NavigationStack {
			List(posts) { post in
				if searchText.isEmpty || post.contains(searchText) {
					PostRow(post: post)
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
