My search search algorithm simply converts all the words in the search bar into an API request string of the form "q=word1+word2+word3..."

In addition to the requirements, I implemented these features:
- data validation that alerts users when their search is invalid (empty, non-alphabetical characters)
- search bar with search button that reacts to return keypress
- persistent article bookmarking & unbookmarking
- separate viewcontroller to see & view only bookmarked articles
