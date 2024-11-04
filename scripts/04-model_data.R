#### Preamble ####
# Purpose: Build a model to predict the winner of the election using cleaned poll data
# Author: Xinze Wu
# Date: 2 November 2024
# Contact: kerwin.wu@utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(ggplot2)

#### Load cleaned data ####
polls_data_cleaned <- read_csv("data/02-analysis_data/cleaned_president_polls.csv")

#### Model Setup ####
# Build a logistic regression model to predict the probability of winning (binary outcome: win)
win_model <- stan_glm(
  formula = win ~ pollscore + sample_size + party_binary + pct,
  data = polls_data_cleaned,
  family = binomial(link = "logit"),
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
  seed = 853
)

#### Model Summary ####
# Print model summary to understand the significance of each predictor
print(summary(win_model))

#### Predicting Outcomes ####
# Generate predicted probabilities of winning
polls_data_cleaned <- polls_data_cleaned %>%
  mutate(predicted_win_prob = predict(win_model, type = "response"))

# Display a few rows of data with predicted probabilities
polls_data_cleaned %>%
  dplyr::select(state, candidate_name, pct, predicted_win_prob) %>%
  head() %>%
  gt() %>%
  tab_header(
    title = "Predicted Win Probabilities",
    subtitle = "Displaying a few sample predictions"
  )

#### Save Model and Predictions ####
# Save the model for future use
saveRDS(win_model, "models/election_win_model.rds")

# Save the data with predictions
write_csv(polls_data_cleaned, "data/04-model_results/polls_with_predictions.csv")
