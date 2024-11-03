#### Preamble ####
# Purpose: Exploratory Data Analysis (EDA) and Modeling for US Election Forecast
# Author: Xinze Wu
# Date: 2 November 2024
# Contact: kerwin.wu@utoronto.ca
# License: MIT


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

# Test that there are no missing values in the dataset
if (all(!is.na(analysis_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Test that 'pollscore' is numeric
if (is.numeric(analysis_data$pollscore)) {
  message("Test Passed: The 'pollscore' column is numeric.")
} else {
  stop("Test Failed: The 'pollscore' column is not numeric.")
}

# Test that there are no empty strings in 'state' or 'pollster' columns
if (all(analysis_data$state != "")) {
  message("Test Passed: There are no empty strings in 'state'")
} else {
  stop("Test Failed: There are empty strings in 'state' column.")
}


