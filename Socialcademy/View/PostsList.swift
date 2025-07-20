//
//  PostsList.swift
//  Socialcademy
//
//  Created by Maël Colomé on 19/07/2025.
//

import SwiftUI

struct PostsList: View {
	@State var viewModel = PostsViewModel()
	@State private var searchText: String = ""
	@State private var showNewPostForm = false

	var body: some View {
		NavigationStack {
			Group {
				switch viewModel.posts {
				case .loading:
					ProgressView()
				case let .error(error):
					EmptyListView(
						title: "Cannot Load Posts",
						message: error.localizedDescription,
						retryAction: {
							viewModel.fetchPosts()
						}
					)
				case .empty:
					EmptyListView(
						title: "No Posts",
						message: "There aren't any posts yet."
					)
				case .loaded(let posts):
					let filteredPosts = posts.filter {
						searchText.isEmpty || $0.contains(searchText)
					}

					if filteredPosts.isEmpty {
						ContentUnavailableView.search
					} else {
						List {
							ForEach(filteredPosts, id: \.id) { post in
								let postRowViewModel = viewModel.makePostRowViewModel(for: post)
								PostRow(viewModel: postRowViewModel)
							}
						}
						.animation(.default, value: filteredPosts)
					}
				}
			}
			.navigationTitle("Posts")
			.toolbar {
				Button {
					showNewPostForm = true
				} label: {
					Label("New Post", systemImage: "square.and.pencil")
				}
			}
			.sheet(isPresented: $showNewPostForm) {
				NewPostForm(createAction: viewModel.makeCreateAction())
			}
			.searchable(text: $searchText, prompt: "Search post")
		}
		.onAppear {
			viewModel.fetchPosts()
		}
	}
}

// MARK: - Previews

@MainActor
private func makePostsList(state: Loadable<[Post]>) -> some View {
	let postsRepository = PostsRepositoryStub(state: state)
	let viewModel = PostsViewModel(postsRepository: postsRepository)
	return PostsList(viewModel: viewModel)
}

#Preview {
	PostsList()
}

#Preview("Posts - Loaded") {
	makePostsList(state: .loaded([Post.testPost]))
}

#Preview("Posts - Empty") {
	makePostsList(state: .empty)
}

#Preview("Posts - Error") {
	makePostsList(state: .previewError)
}

#Preview("Posts - Loading") {
	makePostsList(state: .loading)
}
