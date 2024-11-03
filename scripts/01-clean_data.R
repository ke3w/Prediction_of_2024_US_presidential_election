#### Preamble ####
# Purpose: Cleans the raw plane data recorded by two observers..... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 6 April 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
library(tidyverse)
library(MASS)

#### Load data ####
# Load the polling data directly from the provided CSV file
data_path <- "data/01-raw_data/president_polls.csv"
election_data <- read_csv(data_path)

#### Clean data ####
# Remove unnecessary columns and handle missing values
cleaned_data <- election_data %>%
  dplyr::select(poll_id, pollster, pollscore, sample_size, state, candidate_name, pct) %>%
  filter(!is.na(pct) & sample_size > 0 & !is.na(pollscore) & !is.na(state) & !is.na(candidate_name) & !is.na(pollster)) %>% # Remove rows with any missing values
  mutate(
    state = as.factor(state),
    pollster = as.factor(pollster),
    candidate_name = as.factor(candidate_name),
    log_sample_size = log(sample_size) # Log-transform sample size
  )

# Remove outliers based on sample size
cleaned_data <- cleaned_data %>%
  filter(sample_size < quantile(sample_size, 0.99)) # Remove top 1% of sample sizes as outliers

# Save the cleaned data
write_csv(cleaned_data, "data/02-analysis_data/cleaned_president_polls.csv")


