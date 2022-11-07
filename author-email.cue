import (
  "encoding/json"
  "strings" // a builtin package
)
#Predicate: {
  Data: string
  Timestamp: string
  ...
}
#AuthorEmail: {
    author: string
    author: =~ "^.*@example.com$"
}
predicate: #Predicate & {
  Data: string
  jsonData: {...} & json.Unmarshal(Data) & {
    author: #AuthorEmail.author
  }              
}



