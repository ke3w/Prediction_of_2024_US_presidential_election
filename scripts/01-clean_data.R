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
clean_president_polls <- read_csv("data/01-raw_data/president_polls.csv") %>%
  select(candidate_name, state, start_date, end_date, sample_size, numeric_grade) %>%
  clean_names()

# Create binary variable for state or national polls and modify state names
clean_president_polls <- clean_president_polls %>%
  mutate(
    state = str_replace_all(state, c("Maine CD-[12]" = "Maine",
                                     "Nebraska CD-[1-3]" = "Nebraska")),
    end_date = mdy(end_date),
    start_date = mdy(start_date),
    is_harris = ifelse(candidate_name == "Kamala Harris", 1, 0)
  ) %>%
  drop_na(sample_size, numeric_grade, state)

# Filter for high quality pollsters and state-specific Harris and Trump polls
clean_president_polls <- clean_president_polls %>%
  filter(candidate_name %in% c("Kamala Harris", "Donald Trump"),
         start_date >= ymd("2024-07-21"))

#### Identify, Count, and Drop Duplicates ####
# Drop duplicates and keep only unique rows
num_duplicates <- sum(duplicated(clean_president_polls))
message("Number of duplicate observations: ", num_duplicates)

clean_president_polls <- distinct(clean_president_polls)
message("Number of rows after removing duplicates: ", nrow(clean_president_polls))

#### Save data ####
write_parquet(clean_president_polls, "data/02-analysis_data/cleaned_president_polls.parquet")
