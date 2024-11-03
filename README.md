# Prediction of 2024 U.S Presidential election

## Overview

This project uses a linear or generalized linear model to forecast the outcome of the upcoming U.S. presidential 
election, based on aggregated polling data (“poll-of-polls”) following methodologies outlined by Blumenthal (2014) 
and Pasek (2015). This approach leverages multiple polls to predict trends, and ultimately forecast the popular vote.
Our analysis includes two detailed appendices on a chosen pollster’s methodology and a proposed ideal survey, alongside 
data-driven forecasting models and insights.

## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from "https://projects.fivethirtyeight.com/polls/president-general/2024/national/".
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models. 
-   `other` contains relevant details about LLM chat interactions.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.


## Statement on LLM usage

Aspects of the code were written with the help of the auto-complete tool, Codriver. The abstract and introduction were written with the help of ChatHorse and the entire chat history is available in inputs/llms/usage.txt.