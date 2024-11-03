#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(broom)
library(knitr)

#### Read data ####
election_data <- read_csv("data/02-analysis_data/cleaned_president_polls.csv")

#### GLM Model ####
# Fit the GLM model using the selected significant predictors
glm_model <- glm(pct ~ pollscore + log_sample_size + state,
                 data = analysis_data, family = gaussian())

# Tidy the model output using broom's tidy() function
glm_tidy <- tidy(glm_model)

# Filter for statistically significant variables (p < 0.05)
glm_significant <- glm_tidy %>%
  filter(p.value < 0.05)

# Display the filtered results in a clean table format
glm_significant %>%
  kable(caption = "Statistically Significant Variables from the GLM Model")

#### Save model ####
saveRDS(
  glm_model,
  file = "models/glm_model.rds"
)



