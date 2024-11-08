#### Preamble ####
# Purpose: Conduct exploratory data analysis on cleaned presidential polls data
# Author: Xinze Wu
# Date: 2 November 2024
# Contact: kerwin.wu@utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(arrow)

#### Read upcoming presidential election forecast data ####
clean_president_polls <- read_parquet("data/02-analysis_data/cleaned_president_polls.parquet")

# Create candidate label for Harris and Trump
clean_president_polls <- clean_president_polls %>%
  mutate(candidate_label = ifelse(is_harris == 1, "Harris", "Trump"))

#### Summary Statistics ####
summary_table <- clean_president_polls %>%
  summarize(across(
    c(pct, sample_size),
    list(mean = ~ mean(.x, na.rm = TRUE),
         sd = ~ sd(.x, na.rm = TRUE),
         min = ~ min(.x, na.rm = TRUE),
         max = ~ max(.x, na.rm = TRUE)
    )
  )) %>%
  pivot_longer(cols = everything(), names_to = "Statistic", values_to = "Value")

#### Plot 1: Distribution of Candidate Support Percentages ####
ggplot(clean_president_polls, aes(x = pct, fill = candidate_name)) +
  geom_histogram(bins = 20, color = "black", alpha = 0.7) +
  labs(title = "Distribution of Candidate Support Percentages", 
       x = "Percentage", 
       y = "Frequency", 
       fill = "Candidate Name") +
  facet_wrap(~ candidate_name)

#### Plot 2: Distribution of Polls by Pollster ####
ggplot(clean_president_polls %>% count(pollster) %>% filter(n > 20), 
       aes(x = reorder(pollster, -n), y = n)) +
  geom_bar(stat = "identity", fill = "blue", alpha = 0.7) +
  labs(title = "Distribution of Polls by Pollster", x = "Pollster", y = "Number of Polls") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#### Plot 3: Distribution of Polls by State ####
ggplot(clean_president_polls %>% count(state), 
       aes(x = reorder(state, -n), y = n)) +
  geom_bar(stat = "identity", fill = "blue", alpha = 0.7) +
  labs(title = "Number of Polls by State", x = "State", y = "Number of Polls") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

#### Plot 4: Distribution of Poll Sample Sizes ####
ggplot(clean_president_polls, aes(x = sample_size)) +
  geom_histogram(aes(y = ..density..), bins = 30, fill = "orange", color = "black", alpha = 0.7) +
  geom_density(color = "blue", size = 1) +
  labs(title = "Distribution of Poll Sample Sizes with Density Curve", 
       x = "Sample Size", 
       y = "Density") +
  scale_x_continuous(labels = scales::comma)

#### Plot 5: Distribution of Polls by Harris vs Trump ####
ggplot(clean_president_polls, aes(x = candidate_label)) +
  geom_bar(fill = "purple", alpha = 0.7) +
  labs(title = "Distribution of Polls by Harris vs Trump", x = "Candidate", y = "Number of Polls")
