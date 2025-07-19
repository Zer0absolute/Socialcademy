//
//  PostList.swift
//  Socialcademy
//
//  Created by Maël Colomé on 19/07/2025.
//

import SwiftUI

struct PostsList: View {
	@State private var viewModel = PostsViewModel()
	@State private var searchText: String = ""
	@State private var showNewPostForm = false
	
	var filteredPosts: [Post] {
		if searchText.isEmpty {
			return viewModel.posts
		} else {
			return viewModel.posts.filter { $0.contains(searchText) }
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
			.toolbar {
				Button {
					showNewPostForm = true
				} label: {
					Label("New Post", systemImage: "square.and.pencil")
				}
			}
		}
		.sheet(isPresented: $showNewPostForm) {
			NewPostForm(createAction: viewModel.makeCreateAction())
		}
    }
}

#Preview {
    PostsList()
}
