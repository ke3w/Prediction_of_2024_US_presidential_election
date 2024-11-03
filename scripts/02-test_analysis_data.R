#### Preamble ####
# Purpose: Exploratory Data Analysis (EDA) and Modeling for US Election Forecast
# Author: [Your Name]
# Date: [Current Date]
# Contact: [Your Contact Information]
# License: MIT
# Pre-requisites: Requires cleaned presidential polling data saved in 'data/02-analysis_data/cleaned_president_polls.csv'
# Any other information needed? N/A


#### Workspace setup ####
library(tidyverse)
library(MASS)
library(broom)
library(knitr)

#### Load data ####
analysis_data <- read_csv("data/02-analysis_data/cleaned_president_polls.csv") %>% as_tibble()

# Test if the data was successfully loaded
if (exists("analysis_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}

#### Test data ####

# Test that the dataset has the correct number of rows
if (nrow(analysis_data) > 0) {
  message("Test Passed: The dataset has rows.")
} else {
  stop("Test Failed: The dataset has no rows.")
}

# Test that the dataset has at least 4 columns (pollscore, log_sample_size, state, pollster)
if (ncol(analysis_data) >= 4) {
  message("Test Passed: The dataset has at least 4 columns.")
} else {
  stop("Test Failed: The dataset does not have at least 4 columns.")
}

# Test that the 'state' column is character type
if (is.character(analysis_data$state)) {
  message("Test Passed: The 'state' column is of type character.")
} else {
  stop("Test Failed: The 'state' column is not of type character.")
}

# Test that the 'pollster' column is character type
if (is.character(analysis_data$pollster)) {
  message("Test Passed: The 'pollster' column is of type character.")
} else {
  stop("Test Failed: The 'pollster' column is not of type character.")
}

# Test that there are no missing values in the dataset
if (all(!is.na(analysis_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Test that 'pollster' contains at least 2 unique values
if (length(unique(analysis_data$pollster)) >= 2) {
  message("Test Passed: The 'pollster' column contains at least 2 unique values.")
} else {
  stop("Test Failed: The 'pollster' column does not contain at least 2 unique values.")
}

# Test that 'log_sample_size' is numeric
if (is.numeric(analysis_data$log_sample_size)) {
  message("Test Passed: The 'log_sample_size' column is numeric.")
} else {
  stop("Test Failed: The 'log_sample_size' column is not numeric.")
}

# Test that 'pollscore' is numeric
if (is.numeric(analysis_data$pollscore)) {
  message("Test Passed: The 'pollscore' column is numeric.")
} else {
  stop("Test Failed: The 'pollscore' column is not numeric.")
}

# Test that there are no empty strings in 'state' or 'pollster' columns
if (all(analysis_data$state != "" & analysis_data$pollster != "")) {
  message("Test Passed: There are no empty strings in 'state' or 'pollster' columns.")
} else {
  stop("Test Failed: There are empty strings in 'state' or 'pollster' columns.")
}

