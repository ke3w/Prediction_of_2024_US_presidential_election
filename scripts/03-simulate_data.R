#### Preamble ####
# Purpose: Simulate a dataset for a U.S. Presidential Election analysis
# Author: Xinze Wu
# Date: 2 November 2024
# Contact: kerwin.wu@utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
set.seed(853)

#### Parameters ####
n_samples <- 1000
vote_min <- 30
vote_max <- 70
sample_size_min <- 500
sample_size_max <- 5000

#### Simulate data ####
# State names
states <- c("Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado",
            "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", 
            "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", 
            "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", 
            "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", 
            "New Hampshire", "New Jersey", "New Mexico", "New York", 
            "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", 
            "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", 
            "Tennessee", "Texas", "Utah", "Vermont", "Virginia", 
            "Washington", "West Virginia", "Wisconsin", "Wyoming")

# Parties
parties <- c("Democratic", "Republican")

# Generate sample data
poll_scores <- rnorm(n_samples, mean = 0, sd = 1) # Simulate poll scores with a normal distribution
sample_sizes <- sample(sample_size_min:sample_size_max, n_samples, replace = TRUE) # Simulate sample sizes
states_sampled <- sample(states, n_samples, replace = TRUE) # Randomly sample states
parties_sampled <- sample(parties, n_samples, replace = TRUE, prob = c(0.5, 0.5)) # Equal probability for both parties
vote_percentages <- round(runif(n_samples, vote_min, vote_max), 2) # Simulate vote percentages

# Create a data frame
simulated_election_data <- tibble(
  state = states_sampled,
  pollscore = poll_scores,
  sample_size = sample_sizes,
  party = parties_sampled,
  vote_percentage = vote_percentages
)

#### Save data ####
write_csv(simulated_election_data, "data/02-analysis_data/simulated_data.csv")
head(simulated_election_data)

