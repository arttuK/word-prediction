# prediction.R ####
# Coursera Data Science Capstone Project (https://www.coursera.org/course/dsscapstone)
# Script for predicting a NextWord given an input of any length using stupid backoff algorithm
# 2016-01-23

# Libraries and options ####
library(dplyr)
library(quanteda)
library(wordcloud)
library(RColorBrewer)

# Transfer to quanteda corpus format and segment into sentences ####
fun.corpus = function(x) {
    corpus(unlist(segment(x, 'sentences')))
}

# Tokenize ####
fun.tokenize = function(x, ngramSize = 1, simplify = T) {
    
    # Do some regex magic with quanteda
    toLower(
        quanteda::tokenize(x,
            removeNumbers = T,
            removePunct = T,
            removeSeparators = T,
            removeTwitter = T,
            ngrams = ngramSize,
            concatenator = " ",
            simplify = simplify
        ) 
    )
}

# Parse tokens from input text ####

fun.input = function(x) {
   
    # If empty input, put both words empty
    if(x == "") {
        input1 = data_frame(word = "")
        input2 = data_frame(word = "")
    }
        # Tokenize with same functions as training data
        if(length(x) ==1) {
        y = data_frame(word = fun.tokenize(corpus(x)))
        
        }
            # If only one word, put first word empty
            if (nrow(y) == 1) {
            input1 = data_frame(word = "")
            input2 = y
        
                # Get last 2 words    
            }   else if (nrow(y) >= 1) {
                    input1 = tail(y, 2)[1, ]
                    input2 = tail(y, 1)
                }
    
    #  Return data frame of inputs 
    inputs = data_frame(words = unlist(rbind(input1,input2)))
return(inputs)
}

# Predict using stupid backoff algorithm ####

fun.predict = function(x, y, n = 100) {
    
    # Predict giving just the top 1-gram words, if no input given
    if(x == "" & y == "") {
        prediction = dfTrain1 %>%
            select(NextWord, freq)
            
        # Predict using 3-gram model
    }   else if(x %in% dfTrain3$word1 & y %in% dfTrain3$word2) {
            prediction = dfTrain3 %>%
                filter(word1 %in% x & word2 %in% y) %>%
                select(NextWord, freq)
        
            # Predict using 2-gram model
        }   else if(y %in% dfTrain2$word1) {
                prediction = dfTrain2 %>%
                    filter(word1 %in% y) %>%
                    select(NextWord, freq)
                
                # If no prediction found before, predict giving just the top 1-gram words
            }   else{
                    prediction = dfTrain1 %>%
                        select(NextWord, freq)
                }
    
# Return predicted word in a data frame
return(prediction[1:n, ])
}