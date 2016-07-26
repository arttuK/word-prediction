# validation.R ####
# Coursera Data Science Capstone Project (https://www.coursera.org/course/dsscapstone)
# Validation script for fine tuning the word prediction model
# 2016-01-23

# Libraries and options ####

# source('prepare.data.R')
# source('shiny/prediction.R')

# Prepare validation sets ####

# transform validation set to quanteda format
valid = fun.corpus(valid)

# Get 2-gram tokens 
valid2 = fun.tokenize(valid, 2, T)
valid2 = data_frame(NextWord = valid2) %>%
    separate(NextWord, c('word2', 'NextWord'), ' ')
# Put empty string as word1
valid2 = mutate(valid2, word1 = rep("", nrow(valid2))) %>%
    select(word1, word2, NextWord)

# Get 3-gram tokens
valid3 = fun.tokenize(valid, 3, T)
valid3 = data_frame(NextWord = valid3) %>%
    separate(NextWord, c('word1', 'word2', 'NextWord'), ' ')

# Accuracy function. Here accuracy means percantage of cases where correct word is predicted, ####
# within defined number of suggested words)

fun.accu = function(x) {
    
    # Apply prediction function to each input line 
    y = mapply(fun.predict, x$word1, x$word2)
    
    # Calculate accuracy
    accuracy = sum(ifelse(x$NextWord %in% unlist(y), 1, 0) / length(y))

# Return accuracy percentage
return(accuracy)
}

# Results ####

# Rounding precision
accuRound = 2

# Accuracy using 1 previous word and 5 suggestions
nSuggestions = 5
accuOneFive = round(fun.accu(valid2), accuRound)

# Accuracy using 1 previous word and 3 suggestions
nSuggestions = 3
accuOneThree = round(fun.accu(valid2), accuRound)

# Accuracy using 1 previous word and 1 suggestion
nSuggestions = 1
accuOneOne = round(fun.accu(valid2), accuRound)

# Accuracy using 2 previous words and 5 suggestions
nSuggestions = 5
accuTwoFive = round(fun.accu(valid3), accuRound)

# Accuracy using 2 previous words and 3 suggestions
nSuggestions = 3
accuTwoThree = round(fun.accu(valid3), accuRound)

# Accuracy using 2 previous words and 1 suggestion
nSuggestions = 1
accuTwoOne = round(fun.accu(valid3), accuRound)

# Summary table
accuSummary = data.frame(Suggest5 = c(accuTwoFive, accuOneFive),
                         Suggest3 = c(accuTwoThree, accuOneThree),
                         Suggest1 = c(accuTwoOne, accuOneOne),
                         row.names = c('Previous2', 'Previous1')
                         )
print(accuSummary)

# Validation function
fun.finalAccu = function(x, round = accuRound, n = nSuggestions) {
    accuOneFive = round(fun.accu(x), accuRound, n)
}

