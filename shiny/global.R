# global.R ####
# Coursera Data Science Capstone Project (https://www.coursera.org/course/dsscapstone)
# Shiny script for loading data into global environment
# 2016-02-05

# Libraries and options ####
library(shiny)

# Load data  ####
dfTrain1 =  readRDS(file = './data/dfTrain1.rds')
dfTrain2 =  readRDS(file = './data/dfTrain2.rds')
dfTrain3 =  readRDS(file = './data/dfTrain3.rds')