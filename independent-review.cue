import (
  "encoding/json"
  "strings"
)
#Predicate: {
  Data: string
  Timestamp: string
  ...
}
#IndependentReview: {
author:   string
reviewer: string & !=author
}          
predicate: #Predicate & {
  Data: string
  jsonData: {...} & json.Unmarshal(Data) & {
    #IndependentReview                
  }              
}
