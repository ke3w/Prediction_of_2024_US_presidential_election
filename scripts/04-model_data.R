#### Preamble ####
# Purpose: Build a model to predict the winner of the election using cleaned poll data
# Author: Xinze Wu
# Date: 2 November 2024
# Contact: kerwin.wu@utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(arrow)
library(rsample)
library(performance)

#### Read upcoming presidential election forecast data ####
clean_president_polls <- read_parquet("data/02-analysis_data/cleaned_president_polls.parquet")

#### Add Weights and Prepare Dataset ####
clean_president_polls <- clean_president_polls %>%
  mutate(
    weight = numeric_grade * (sample_size / mean(sample_size)),
    pollster = as.factor(pollster),
    state = as.factor(state),
    candidate_label = ifelse(is_harris == 1, "Harris", "Trump")
  )

#### Bayesian Model ####
set.seed(437)

# Fit Bayesian model
bayesian_model <- stan_glmer(
  is_harris ~ pct + (1 | pollster) + (1 | state),
  data = clean_president_polls,
  family = binomial(link = "logit"),
  prior = normal(0.5, 0.1, autoscale = TRUE),
  prior_intercept = normal(0.5, 0.1, autoscale = TRUE),
  weights = weight,
  cores = 4,
  adapt_delta = 0.95
)

# Predict probabilities and determine state and overall winners
clean_president_polls <- clean_president_polls |> 
  mutate(
    predicted_prob_harris = posterior_predict(bayesian_model, newdata = clean_president_polls, type = "response") |> colMeans(),
    winner_harris = ifelse(predicted_prob_harris > 0.5, 1, 0)
  )

# Calculate and print overall predicted percentages
overall_predicted_prob_harris <- mean(clean_president_polls$predicted_prob_harris)
cat("Overall Percentage for Kamala Harris:", overall_predicted_prob_harris * 100, "%\n")
cat("Overall Percentage for Donald Trump:", (1 - overall_predicted_prob_harris) * 100, "%\n")

# State-level predictions and state winner counts
state_predictions <- clean_president_polls %>%
  group_by(state) %>%
  summarize(
    avg_predicted_prob_harris = mean(predicted_prob_harris),
    state_winner = ifelse(avg_predicted_prob_harris > 0.5, "Harris", "Trump")
  )

overall_winner_summary <- count(state_predictions, state_winner)

# Print state-level predictions and overall winner summary
print(state_predictions, n = Inf)
print(overall_winner_summary)

### Model Validation/Checking ###
set.seed(123)
# Train/test split
train_indices <- sample(seq_len(nrow(clean_president_polls)), size = 0.7 * nrow(clean_president_polls))
training_data <- clean_president_polls[train_indices, ] %>% mutate(pct_scaled = scale(pct))
testing_data <- clean_president_polls[-train_indices, ] %>% filter(pollster %in% unique(training_data$pollster))

# Ensure 'state' and 'pollster' levels in testing_data match those in training_data
testing_data$state <- factor(testing_data$state, levels = levels(training_data$state))
testing_data$pollster <- factor(testing_data$pollster, levels = levels(training_data$pollster))

# Fit Bayesian model with training data
model_validation_train <- stan_glmer(
  is_harris ~ pct + (1 | pollster) + (1 | state),
  data = training_data,
  family = binomial(link = "logit"),
  prior = normal(0.5, 0.1, autoscale = TRUE),
  prior_intercept = normal(0.5, 0.1, autoscale = TRUE),
  weights = weight,
  cores = 4,
  adapt_delta = 0.99,
  seed = 123
)

# Posterior predictive check
pp_check(model_validation_train)

# Filter out rows with new levels of 'state' or 'pollster' that were not seen in training data
testing_data <- testing_data %>%
  filter(state %in% levels(training_data$state), pollster %in% levels(training_data$pollster))

# Make predictions on the filtered test set for the Bayesian model
testing_data <- testing_data |> 
  mutate(
    predicted_prob_harris = posterior_predict(model_validation_train, newdata = testing_data, type = "response") |> colMeans(),
    winner_harris = ifelse(predicted_prob_harris > 0.5, 1, 0)
  )

# Calculate accuracy for Bayesian model
accuracy_b <- mean(testing_data$is_harris == testing_data$winner_harris)
cat("Bayesian Model - Accuracy:", accuracy_b, "\n")

# Fit Logistic Regression model
model_logistic_train <- glm(
  is_harris ~ pollster + state + pct,
  data = training_data,
  family = binomial(link = "logit"),
  weights = weight
)

check_collinearity(model_logistic_train)

# Make predictions on the test set for the logistic model
testing_data <- testing_data |> 
  mutate(
    predicted_prob_harris = predict(model_logistic_train, newdata = testing_data, type = "response"),
    winner_harris = ifelse(predicted_prob_harris > 0.5, 1, 0)
  )

# Calculate accuracy for Logistic model
accuracy_l <- mean(testing_data$is_harris == testing_data$winner_harris)
cat("Logistic Model - Accuracy:", accuracy_l, "\n")

#### Save Model ####
saveRDS(bayesian_model, file = "models/first_model.rds")
