import (
  "encoding/json"
  "strings" // a builtin package
)

#Predicate: {
  Data: string
  Timestamp: string
  ...
}

// The elipses makes this struct "open"
// which allows for any other fields
// type? is optional because of the ?
// branch can be set to main or origin/main
// uri must start with https://github.com/example/
#Repo: {
    branch: "main" | "origin/main"
    uri: string
    uri: =~ "https:\/\/github.com\/example\/.*$"
    type?: string
    ...    // open struct
}

predicate: #Predicate & {
    Data: string
    jsonData: {...} & json.Unmarshal(Data) & {
      repo: #Repo
    }              
}

