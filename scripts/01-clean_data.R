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
library(gt)
library(arrow)

#### Load data ####
election_data <- read_csv("data/01-raw_data/president_polls.csv")

#### Clean data ####
# Remove unnecessary columns and handle missing values
polls_data_cleaned <- election_data %>%
  dplyr::select(pollscore, sample_size, state, party, candidate_name, pct, end_date) %>%
  filter(!is.na(pollscore) & !is.na(sample_size) & !is.na(state) & !is.na(pct) & !is.na(end_date))

# Create binary 'win' variable where pct > 50 is considered a win
polls_data_cleaned <- polls_data_cleaned %>%
  mutate(win = ifelse(pct > 50, 1, 0),
         party_binary = ifelse(party == "DEM", 1, 0))

# Display cleaned data
polls_data_cleaned %>%
  head() %>%
  gt() %>%
  tab_header(
    title = "Cleaned Poll Data",
    subtitle = "Displaying a few sample of the cleaned data"
  )

#### Save data ####
write_csv(polls_data_cleaned, "data/02-analysis_data/cleaned_president_polls.csv")
write_parquet(polls_data_cleaned, "data/02-analysis_data/cleaned_president_polls.parquet")

