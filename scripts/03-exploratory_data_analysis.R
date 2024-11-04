#### Preamble ####
# Purpose: Conduct exploratory data analysis on cleaned presidential polls data
# Author: Xinze Wu
# Date: 2 November 2024
# Contact: kerwin.wu@utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(ggplot2)
library(gt)

#### Load cleaned data ####
polls_data_cleaned <- read_csv("data/02-analysis_data/cleaned_president_polls.csv")

#### Summary Statistics ####
# Summary of numeric variables
summary_stats <- polls_data_cleaned %>%
  summarise(
    avg_pollscore = mean(pollscore, na.rm = TRUE),
    avg_sample_size = mean(sample_size, na.rm = TRUE),
    avg_pct = mean(pct, na.rm = TRUE),
    win_rate = mean(win, na.rm = TRUE)
  )

# Display summary statistics
summary_stats %>%
  gt() %>%
  tab_header(
    title = "Summary Statistics of Cleaned Poll Data",
    subtitle = "Average values for key variables"
  )

#### Distribution Plots ####
# Poll percentage distribution by party
polls_data_cleaned %>%
  ggplot(aes(x = pct, fill = party)) +
  geom_histogram(binwidth = 2, alpha = 0.7, position = "identity") +
  labs(
    title = "Distribution of Poll Percentages by Party",
    x = "Poll Percentage",
    y = "Count"
  ) +
  theme_minimal()

# Sample size distribution
polls_data_cleaned %>%
  ggplot(aes(x = sample_size)) +
  geom_histogram(binwidth = 500, fill = "steelblue", alpha = 0.7) +
  labs(
    title = "Distribution of Sample Sizes",
    x = "Sample Size",
    y = "Count"
  ) +
  theme_minimal()

# Poll score by state
polls_data_cleaned %>%
  ggplot(aes(x = reorder(state, pollscore, FUN = median), y = pollscore)) +
  geom_boxplot(fill = "lightgreen", alpha = 0.7) +
  coord_flip() +
  labs(
    title = "Poll Scores by State",
    x = "State",
    y = "Poll Score"
  ) +
  theme_minimal()

#### Relationship Analysis ####
# Poll percentage vs. sample size colored by party
polls_data_cleaned %>%
  ggplot(aes(x = sample_size, y = pct, color = party)) +
  geom_point(alpha = 0.6) +
  labs(
    title = "Poll Percentage vs. Sample Size by Party",
    x = "Sample Size",
    y = "Poll Percentage"
  ) +
  theme_minimal()

# Average poll percentage by party
avg_pct_party <- polls_data_cleaned %>%
  group_by(party) %>%
  summarise(avg_pct = mean(pct, na.rm = TRUE))

# Display average poll percentage by party
avg_pct_party %>%
  gt() %>%
  tab_header(
    title = "Average Poll Percentage by Party",
    subtitle = "Comparison of average poll percentages between parties"
  )

#### Save EDA Results ####
# Save summary statistics as CSV
write_csv(summary_stats, "data/03-eda_results/summary_statistics.csv")
# Save average poll percentage by party as CSV
write_csv(avg_pct_party, "data/03-eda_results/avg_pct_party.csv")
