#### Preamble ####
# Purpose: Build a model to predict the winner of the election using cleaned poll data
# Author: Xinze Wu
# Date: 2 November 2024
# Contact: kerwin.wu@utoronto.ca
# License: MIT

#### Workspace setup ####
library(readr)
library(tidyverse)
library(arrow)
library(janitor)
library(lubridate)


#### Clean data ####
clean_president_polls <- read_csv("data/01-raw_data/president_polls.csv", 
                                  col_types = cols(poll_id = col_skip(), 
                                                   pollster_id = col_skip(), sponsor_ids = col_skip(), 
                                                   sponsors = col_skip(), display_name = col_skip(), 
                                                   pollster_rating_id = col_skip(), 
                                                   pollster_rating_name = col_skip(), 
                                                   pollscore = col_skip(), methodology = col_skip(), 
                                                   transparency_score = col_skip(), 
                                                   sponsor_candidate_id = col_skip(), 
                                                   sponsor_candidate = col_skip(), sponsor_candidate_party = col_skip(), 
                                                   endorsed_candidate_id = col_skip(), 
                                                   endorsed_candidate_name = col_skip(), 
                                                   endorsed_candidate_party = col_skip(), 
                                                   question_id = col_skip(), population = col_skip(), 
                                                   subpopulation = col_skip(), population_full = col_skip(), 
                                                   tracking = col_skip(), created_at = col_skip(), 
                                                   notes = col_skip(), url = col_skip(), 
                                                   url_article = col_skip(), url_topline = col_skip(), 
                                                   url_crosstab = col_skip(), source = col_skip(), 
                                                   internal = col_skip(), partisan = col_skip(), 
                                                   race_id = col_skip(), cycle = col_skip(), 
                                                   office_type = col_skip(), seat_number = col_skip(), 
                                                   seat_name = col_skip(), election_date = col_skip(), 
                                                   stage = col_skip(), nationwide_batch = col_skip(), 
                                                   ranked_choice_reallocated = col_skip(), 
                                                   ranked_choice_round = col_skip(), 
                                                   hypothetical = col_skip(), party = col_skip(), 
                                                   answer = col_skip(), candidate_id = col_skip())) |>
  clean_names()

# Create binary variable for state or national polls
clean_president_polls <- clean_president_polls %>%
  mutate(
    state = str_replace(state, "Maine CD-[12]", "Maine"),
    state = str_replace(state, "Nebraska CD-1", "Nebraska"),
    state = str_replace(state, "Nebraska CD-2", "Nebraska"),
    state = str_replace(state, "Nebraska CD-3", "Nebraska"),
    end_date = mdy(end_date),
    start_date = mdy(start_date),
    is_harris = ifelse(candidate_name == "Kamala Harris", 1, 0)) %>%
  drop_na(sample_size) %>% 
  drop_na(numeric_grade) %>%
  drop_na(state)

# Filter for high quality pollsters and state-specific Harris and Trump polls
clean_president_polls <- clean_president_polls %>%
  filter(
    candidate_name %in% c("Kamala Harris", "Donald Trump"),
    start_date >= ymd("2024-07-21")
  ) 

#### Identify, Count, and Drop Duplicates ####
# Identify duplicates
duplicates <- clean_president_polls[duplicated(clean_president_polls), ]

# Drop duplicates and keep only unique rows
clean_president_polls <- clean_president_polls[!duplicated(clean_president_polls), ]
message("Number of rows after removing duplicates: ", nrow(clean_president_polls))

#### Save data ####
write_parquet(clean_president_polls, "data/02-analysis_data/cleaned_president_polls.parquet")
