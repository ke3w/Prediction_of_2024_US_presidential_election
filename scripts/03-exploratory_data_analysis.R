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
library(maps)

#### Read upcoming presidential election forecast data ####
clean_president_polls <- read_parquet("data/02-analysis_data/clean_president_polls.parquet")

#### Summary Statistics ####
summary_table <- clean_president_polls %>%
  summarize(
    mean_pct = mean(pct, na.rm = TRUE),
    sd_pct = sd(pct, na.rm = TRUE),
    min_pct = min(pct, na.rm = TRUE),
    max_pct = max(pct, na.rm = TRUE),
    mean_sample_size = mean(sample_size, na.rm = TRUE),
    sd_sample_size = sd(sample_size, na.rm = TRUE),
    min_sample_size = min(sample_size, na.rm = TRUE),
    max_sample_size = max(sample_size, na.rm = TRUE)
  ) %>%
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
pollsters_over_20 <- clean_president_polls %>%
  count(pollster) %>%
  filter(n > 20)

ggplot(pollsters_over_20, aes(x = reorder(pollster, -n), y = n)) +
  geom_bar(stat = "identity", fill = "blue", alpha = 0.7) +
  labs(title = "Distribution of Polls by Pollster", x = "Pollster", y = "Number of Polls") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#### Plot 3: Distribution of Polls by State ####
state_counts <- clean_president_polls %>%
  count(state)

ggplot(state_counts, aes(x = reorder(state, -n), y = n)) +
  geom_bar(stat = "identity", fill = "green", alpha = 0.7) +
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
clean_president_polls <- clean_president_polls %>%
  mutate(candidate_label = ifelse(is_harris == 1, "Harris", "Trump"))

ggplot(clean_president_polls, aes(x = candidate_label)) +
  geom_bar(fill = "purple", alpha = 0.7) +
  labs(title = "Distribution of Polls by Harris vs Trump", x = "Candidate", y = "Number of Polls")

#### Save EDA Results ####
# Save summary statistics as CSV
write_csv(summary_stats, "data/03-eda_results/summary_statistics.csv")
# Save average poll percentage by party as CSV
write_csv(avg_pct_party, "data/03-eda_results/avg_pct_party.csv")
