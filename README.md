### README.MD
  
This project was the final part of a 10 course Data Science track by Johns Hopkins University on Coursera. It was done as an industry partnership with SwiftKey. The job was to clean and analyze a large corpus of unstructured text and build a word prediction model and use it in a web application.
  
More info here: (http://dataexcursions.com/Word-Prediction-Shiny-App)
  
#### Runbook
  
**Shiny app**
  
1. Data is preloaded into (./shiny/data/)
  
2. ./shiny/prediction.R
	- Contains most of the functions used by the other scripts
  
3. ./shiny/server.R
	- Contains the server side functions
  
4. ./shiny/ui.R
	- Handles the input/output
  
  
**Preparing the data and validation**

1. ./shiny/prediction.R  
	- Contains most of the functions used by the other scripts
  
2. ./prepare_data.R
	- Data is cleaned and tokenized with this
  
3. ./test_prediction.R
	- Run manual tests

4. ./validation.R
	- Run an automated accuracy calculation on validation data
