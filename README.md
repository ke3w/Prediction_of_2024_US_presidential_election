---
editor_options: 
  markdown: 
    wrap: sentence
---

# Prediction of 2024 U.S Presidential election

## Overview 

This repository contains the prediction of the 2024 U.S.
Presidential Election using a Bayesian logistic regression model based on polling data.
By incorporating key variables—such as polling percentage, pollster, and state—and adjusting for poll quality and sample size, the model accounts for both polling variability and regional demographics.
Geographic analysis revealed that Harris holds a slight overall lead, with strong support in western and northeastern states, while Trump has concentrated support in central regions.
Several battleground states, including Michigan, Nevada, and Pennsylvania, were identified as crucial to determining the outcome.
Our findings underscore the value of state-specific polling data and probabilistic modeling in capturing the nuanced dynamics of voter sentiment across different regions.
This approach provides a granular and adaptable forecast of electoral outcomes, predicting a competitive race with a slight advantage for Harris.
This repository also contains an analysis of Ipsos polling methodology and a designed idealized mythology.
Some of the R code used to create this work was adapted from Alexander (2023).

## File Structure 

The repo is structured as:

inputs/data/raw_data contains the raw data used in this investigation.
inputs/data/analysis_data contains the cleaned dataset that was constructed.

models contains fitted models.

other contains copies of LLM conversations, references used in this analysis, along with sketches of the dataset and graphs featured in this report.

outputs/data contains the cleaned data utilized for analysis in this paper, as well as the simulated data used for testing purposes.

outputs/paper contains a PDF version of the final paper, the Quarto file used to generate the PDF, and a file with the paper's references.

scripts contains R scripts for data simulation, downloading, cleaning, and testing.

# Statement on LLM usage

Aspects of the code were written with the help of the AI tool, Chatgpt.
The abstract, introduction methodology and appendix were written with the help of Chatgpt and the entire chat history is available in inputs/llms/usage.txt.
