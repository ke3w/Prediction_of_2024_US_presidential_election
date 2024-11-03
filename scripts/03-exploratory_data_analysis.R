#### Preamble ####
# Purpose: Exploratory Data Analysis (EDA) and Modeling for US Election Forecast
# Author: [Your Name]
# Date: [Current Date]
# Contact: [Your Contact Information]
# License: MIT
# Pre-requisites: Requires cleaned presidential polling data saved in 'data/02-analysis_data/cleaned_president_polls.csv'
# Any other information needed? N/A


#### Workspace setup ####
library(tidyverse)
library(MASS)
library(broom)
library(knitr)

#### Load data ####
analysis_data <- read_csv("data/02-analysis_data/cleaned_president_polls.csv") %>% as_tibble()

#### Exploratory Data Analysis (EDA) ####
# Summary statistics of key variables
summary(analysis_data)

# Distribution of vote percentage (pct) by candidate
analysis_data %>%
  ggplot(aes(x = pct, fill = candidate_name)) +
  geom_histogram(binwidth = 5, alpha = 0.7) +
  labs(title = "Distribution of Vote Percentage by Candidate",
       x = "Vote Percentage",
       y = "Count",
       fill = "Candidate") +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 8),
        axis.text.y = element_text(size = 8),
        legend.text = element_text(size = 6))

# Average poll score by state
analysis_data %>%
  group_by(state) %>%
  summarise(avg_pollscore = mean(pollscore, na.rm = TRUE)) %>%
  ggplot(aes(x = reorder(state, -avg_pollscore), y = avg_pollscore)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Average Poll Score by State",
       x = "State",
       y = "Average Poll Score") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 5)) +
  coord_flip()

#### Stepwise Feature Selection for GLM ####
# Fit a full GLM with all predictors, excluding candidate names
full_model <- glm(pct ~ pollscore + log_sample_size + state + pollster,
                  data = analysis_data, family = gaussian())

# Perform stepwise selection based on AIC
stepwise_model <- stepAIC(full_model, direction = "both")

# Summary of the selected model
summary(stepwise_model)
