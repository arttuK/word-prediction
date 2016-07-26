---
header:
  teaser: 2016-02-08-teaser.png
tags:
  - #coursera
---

### Predicting next words with stupid backoff algorithm

This project was the final part of a 10 course [Data Science track by Johns Hopkins University on Coursera](https://www.coursera.org/specializations/jhu-data-science). It was done as an industry partnership with [SwiftKey](https://swiftkey.com/en). The job was to clean and analyze a large corpus of unstructured text and build a word prediction model and use it in a web application.

**Word Predictor Application:** [https://arttu.shinyapps.io/word_predictor/](https://arttu.shinyapps.io/word_predictor/)

**GitHub:** [https://github.com/arttuK/word-prediction](https://github.com/arttuK/word-prediction)

### The Data

The data is from a corpus called [HC Corpora](http://www.corpora.heliohost.org/aboutcorpus.html). It consists of text files collected from publicly available sources by a web crawler. I used english language files that were gathered from Twitter and different blogs and news sources. This combination should give a rather good mix of general language used today.The data are large text files. Over 4 million lines combined. Unix wordcount gives 102,081,616 individual words. They are not in a sequential order, eg. the lines in the "Blogs" - file are not complete posts and the same post does not continue in the next line.

I used a random sample of 10% from the raw data to build the final model.


### Text Transformations

The process of transforming raw text to useful units for text analysis is called [tokenization](https://en.wikipedia.org/wiki/Lexical_analysis). What kind of transformations are needed is an important choice. In the case of word prediction, it is probably the most important step.

Before tokenization I decided to split the raw data into sentences as it was in rather random order. For word prediction sentence is a reasonable unit. It is hard to predict how the next sentence begins, based on words from previous sentence, unless you have good information on the context.

**Here is a list of transformations that I used (or did not use):**

0. Word Stemming
	- In many NLP tasks you [stem](https://en.wikipedia.org/wiki/Stemming) the words, which means reducing inflected or derived word to its basic part (ie. connection, connected and connecting, would all become connect)
	- I did not do this, because it would greatly reduce the predictive power

1. All text to lower case
	- Removes the problem of beginning of sentence words being “different” than the others.
	- Combined with punctuation, this information	could be used for prediction
	- It would be good to ignore capital letters in the beginning of sentence, but keep them elsewhere to catch names and acronyms correctly

2. Remove numbers
	- Remove tokens that consist only of numbers, but not words that start with digits, e.g. 2day)
	- Numbers are hard to predict or use in word prediction

3. Remove punctuation
	-  With simple ngram-model punctuation causes too many sequences
	- Could be useful with advanced algorhitms combined with other features

4. Remove separators
	- Spaces and variations of spaces, plus tab, newlines, and anything else in the Unicode "separator" category
	- No use for prediction

5. Remove Twitter characters
	- ie.(@ and #)
	- Better to capture only the words

6. Profanity filtering
	- Only filtered the ”Seven Words You Can Never Say on Television" and only in their basic form
	- Trying to get this 100% right would be a daunting and interesting task given the human creativity on the subject

### Prediction Model

To keep the scope of the project managable, I only concidered so called Markov models. They are a class of probabilistic models that assume we can predict the probability of some future unit without looking too far into the past. I based my model on the stupid backoff -algorithm. Despite its name, it actually performs quite well given very large data. Actually, almost as well as some more complex models.

Stupid backoff -algorithm centers around [n-grams](https://en.wikipedia.org/wiki/N-gram). They mean contiguous word sequences of length n. Selection of the size depends on the genre of text you are trying to predict. Higher n-grams are not always preferable for prediction. Also the computing and storage needs grow expotentially with that parameter. I chose to use n-grams of lengts one, two and three. This means that the predictions can be based on maximum two previous words.

#### Basic Idea of the Algorithm used

1. Take the input and use the same text transformations as for the training data and return last two words.
2. Search for two first input words in the 3-grams training data and if matched, predict the third word. If no match, then next step.
3. Search with only the last input word in the first word of 2-grams training data. If matched, predict the second word. If no match, then next step.
4. Predict the most common words in the 1-gram data.

*For more in-depth look, [here](https://lagunita.stanford.edu/c4x/Engineering/CS-224N/asset/slp4.pdf) is a good article on basic text prediction.*

### Testing and Accuracy

Using cross-validation, I first set aside 20% of the data to use as the validation set and the rest was used when building the model. Because of computing limitations, I ended up using only 10% of the validation set. I used the input function (same transformations as with the training data). The resulting 1-grams and 2-grams were given to the prediction algorithm and checked how many times it got the prediction right with a certain number of sugested words.

Results with five, tree and one next word suggestions per prediction per n-gram:

| Suggest 5 | Suggest 3 | Suggest 1 |
| --------- | --------- | --------- |
| 0.76      | 0.73      | 0.65      |
| 0.72      | 0.68      | 0.58      |


So called stopwords (ie. “the”, “to” etc) are very prevalent in English. These make up a high frequency of words in test and validation sets and thus a lot of matches in the validation script. This probably inflates the tested accuracy compared to the perceived usefulness in real world (test set). Usually you want the application to predict words that carry more meaning and are harder to type.

### Lessons Learned

Text prediction is not easy and the field of linguistics is intricate. You have to give credit to the ubiquitous autocorrect. The dictionaries used in real world are tiny compared to this and the models have to be really thought out. Pruning the data would have probably given better accuracy here, but it takes a lot of time and thought. Testing strategy is important to have as soon as possible, so you can iterate between data, model and test results. When dealing with something as complex as human language and millions of data points, you can't just reason your way through. You have to try things and improve step by step. Oh, and note to self: learn some web technologies. The app took more time than it should have.

### Notes on R Packages Used

My first approach was to use the gold standard package for NLP tasks, the [tm](https://cran.r-project.org/web/packages/tm/vignettes/tm.pdf). It turned out to be quite slow with this magnitude of data, even when using samples of n/1000. Also its data structures were complicating the task. I then switched to newer [quanteda](https://cran.r-project.org/web/packages/quanteda/vignettes/quickstart.html) package. It proofed to be faster and more user friendly for basic tasks needed in this assignment.

For more efficient computing, one could use markov chains, hashing or some other more elaborate methods. I wanted to keep it simple and see and play with the data in easy format throughout the exercise. I did most of the work in data table -format with [dplyr](https://cran.r-project.org/web/packages/dplyr/README.html). It was suprisingly fast and was not a bottleneck  when the data manipulation steps were in right sequence.
