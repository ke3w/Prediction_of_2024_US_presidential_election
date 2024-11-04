#### Preamble ####
# Purpose: Cleans the raw plane data recorded by two observers..... [...UPDATE THIS...]
# Author: Xinze Wu
# Date: 2 November 2024
# Contact: kerwin.wu@utoronto.ca
# License: MIT

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

# Create binary 'win' variable indicating if the candidate has the highest percentage in that poll
polls_data_cleaned <- polls_data_cleaned %>%
  group_by(state, end_date) %>%
  mutate(win = ifelse(pct == max(pct), 1, 0),
         party_binary = ifelse(party == "DEM", 1, 0)) %>%
  ungroup()

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
