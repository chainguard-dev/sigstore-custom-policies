#Repo: {
	branch: "main" | "origin/main"
	uri:    string
	uri:    =~"https:\/\/github.com\/example\/.*$"
	type?:  string
	...
}
#AuthorEmail: {
	author: string
	author: =~"^.*@example.com$"
}
#IndependentReview: {
	author:   string
	reviewer: string & !=author
}

exampleCodeReview: {
	#Repo
	#AuthorEmail
	#IndependentReview
}