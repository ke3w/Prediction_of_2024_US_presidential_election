#### Preamble ####
# Purpose: Simulate a dataset for a U.S. Presidential Election analysis
# Author: Xinze Wu
# Date: 2 November 2024
# Contact: kerwin.wu@utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
set.seed(853) # Set seed for reproducibility

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

# Political parties
parties <- c("Democratic", "Republican")

# Simulate poll scores, sample sizes, and vote percentages
poll_scores <- rnorm(1000, mean = 0, sd = 1) # Simulate 1000 poll scores with a normal distribution
sample_sizes <- sample(500:5000, 1000, replace = TRUE) # Simulate sample sizes between 500 and 5000
states_sampled <- sample(states, 1000, replace = TRUE) # Randomly sample states
parties_sampled <- sample(parties, 1000, replace = TRUE, prob = c(0.5, 0.5)) # Equal probability for both parties
vote_percentages <- round(runif(1000, 30, 70), 2) # Simulate vote percentages between 30% and 70%

# Create a data frame
simulated_election_data <- tibble(
  state = states_sampled,
  pollscore = poll_scores,
  sample_size = sample_sizes,
  party = parties_sampled,
  vote_percentage = vote_percentages
)

#### Save data ####
write_csv(simulated_election_data, "data/simulated_data/us_election_simulated_data.csv")

#### Display the simulated data ####
print(simulated_election_data)
