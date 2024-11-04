#### Preamble ####
# Purpose: Improved GLM model for predicting election winner with log transformation
# Author: Xinze Wu
# Date: 3 November 2024
# Contact: kerwin.wu@utoronto.ca
# License: MIT

library(tidyverse)
library(broom)
library(knitr)
library(car)  # For VIF calculation
library(pROC)  # For ROC curve and AUC

#### Read Data ####
model_data <- read_csv("data/02-analysis_data/cleaned_president_polls.csv")

### Transform Data ####
# Apply log transformation to sample_size
model_data <- model_data %>%
  mutate(log_sample_size = log(sample_size))

### Model Data ####
# Fit the GLM model using logistic regression with log-transformed sample size
glm_model <- glm(win ~ pollscore + log_sample_size + state + party_binary, 
                 family = binomial, data = model_data)

#### Multicollinearity Check ####
vif_values <- vif(glm_model)
print(vif_values)

#### Model Fit and Diagnostics ####
# Model summary
glm_summary <- summary(glm_model)
print(glm_summary)

# Tidy the model output using broom's tidy() function
glm_tidy <- tidy(glm_model)

# Display the model coefficients
glm_tidy %>%
  kable(caption = "Model Coefficients from the GLM Model with Log-Transformed Sample Size")

# Calculate and plot ROC Curve to assess model performance
roc_curve <- roc(model_data$win, fitted(glm_model))
plot(roc_curve, main = "ROC Curve for GLM Model with Log-Transformed Sample Size")
auc_value <- auc(roc_curve)
print(paste("AUC Value:", auc_value))

#### Save Model ####
saveRDS(
  glm_model,
  file = "models/glm_model_log_transform.rds"
)
