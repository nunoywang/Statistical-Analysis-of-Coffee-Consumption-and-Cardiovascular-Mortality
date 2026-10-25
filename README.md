# Coffee Consumption and Mortality: A Survival Analysis

A group coursework project developed for Biostatistics at Instituto Superior Técnico, Universidade de Lisboa.

## Overview

This project studies the association between coffee consumption and mortality among individuals with an abnormal P-wave axis or negative P-wave amplitude in lead V1. It uses NHANES III data and linked mortality information, considering both coffee intake and coffee type.

The analysis combines descriptive comparisons with survival-analysis methods to examine differences between groups and associations with mortality over follow-up.

## Methods

- Data preparation and exploratory analysis.
- Comparisons between coffee-consumption groups using statistical tests.
- Kaplan–Meier survival curves.
- Cox proportional hazards models.
- Interpretation of associations in the context of the study population.

## Data Processing Workflow

The data processing workflow consists of three main stages:

1. **Raw Data:** The original datasets, containing information on mortality, coffee consumption, and electrocardiographic measurements, are stored in `data/raw/`.

2. **Data Preparation:** The R script `scripts/dataset.R` processes and organizes the original datasets, producing the analysis-ready datasets stored in `data/processed/`.

3. **Statistical Analysis:** The processed datasets are used for exploratory analysis, statistical comparisons, Kaplan–Meier survival estimation, and Cox proportional hazards modelling.

The separation between raw data, preprocessing code, and processed datasets is intended to make the analytical workflow easier to understand and reproduce.


## Interpretation

This is an observational coursework analysis. Associations between coffee consumption and mortality should not be interpreted as evidence of a causal effect or as individual health recommendations.

## Report

[Read the project report](report.pdf)

## Authors

- Nuno Wang
- Francisco Mendonça
- Mateus Nóbrega
- David Albino

## Academic context

- **Course:** Biostatistics.
- **Institution:** Instituto Superior Técnico, Universidade de Lisboa.
- **Data source:** Third National Health and Nutrition Examination Survey (NHANES III) and linked mortality information.

**Disclaimer:** This text was AI generated.
