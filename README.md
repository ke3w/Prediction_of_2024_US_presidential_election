# **2024 US Presidential Election Forecasting**

## Overview

This repository contains the prediction of the 2024 U.S. Presidential Election using a Bayesian logistic regression model based on polling data. By incorporating key variables—such as polling percentage, pollster, and state—and adjusting for poll quality and sample size, the model accounts for both polling variability and regional demographics. Geographic analysis revealed that Harris holds a slight overall lead, with strong support in western and northeastern states, while Trump has concentrated support in central regions. Several battleground states, including Michigan, Nevada, and Pennsylvania, were identified as crucial to determining the outcome. Our findings underscore the value of state-specific polling data and probabilistic modeling in capturing the nuanced dynamics of voter sentiment across different regions. This approach provides a granular and adaptable forecast of electoral outcomes, predicting a competitive race with a slight advantage for Harris. This repository also contains an analysis of Ipsos polling methodology and a designed idealized mythology. Some of the R code used to create this work was adapted from Alexander (2023).

## File Structure

The repository is organized as follows:

- `data/raw_data`: contains the raw data as obtained from FiveThirtyEight, including the simulated data
- `data/analysis_data`: Contains the cleaned data used for analysis and modeling.
- `models`: Contains the fitted models, including saved models in `.rds` format.
- `other`: Documents any assistance from ChatGPT-4o and preliminary sketches.
- `paper`: contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper.
- `scripts`: Contains the R scripts used to simulate, download, clean, test, analyze and model the data.

## Statement on LLM usage

Aspects of the code were written with the help of the AI tool, Chatgpt. The abstract, introduction methodology and appendix were written with the help of Chatgpt and the entire chat history is available in inputs/llms/usage.txt.