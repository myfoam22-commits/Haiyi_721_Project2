# BIOSTAT 721 — Project 2: Durham Air Pollution, 2018–2020

## Purpose

Clean and summarize daily measurements of carbon monoxide (CO), fine particulate
matter (PM2.5), and ozone (O3) from the U.S. Environmental Protection Agency
(EPA) air monitor at Raleigh–Durham International Airport. The motivating
context is research on air pollution exposure and sickle cell disease (SCD),
but this project performs air-pollution exploratory data analysis only; it does
not analyze patient-level SCD health outcomes.

## Data source and study period

- Source: EPA air-quality measurements from the RDU airport monitor, provided
  for this assignment in three CSV files.
- Coverage: 2018, 2019, and **January–April 2020 only**.
- Required original data files: `data/AQ_2018.csv`, `data/AQ_2019.csv`, and
  `data/AQ_2020.csv`.

## Project files

```text
721_project_2/
├── 721_project_2.Rproj        # RStudio project settings
├── Project2_Report.Rmd              # Analysis and rendered Word report source
├── Project2_Report.docx              # Word report
├── R_function/
│   ├── process_air_quality.R        # Annual CSV cleaning function
│   └── summarise_air_quality.R      # Three-decimal yearly min/max tables
├── data/
│   ├── AQ_2018.csv                  # Add your original file
│   ├── AQ_2019.csv                  # Add your original file
│   └── AQ_2020.csv                  # Add your original file
├── output/
│   └── air_quality_daily_2018_2020.csv  # Created by rendering
└── README.md
```

## How to Reproduce

1. Download the project folder and open `721_project_2.Rproj` in RStudio.
2. Install the required R packages if needed: `readr`, `dplyr`, `tidyr`, `ggplot2`, `lubridate`, `knitr`, and `rmarkdown`.
3. Make sure the original CSV files are in `data/` and the R functions are in `R_function/`.
4. Open `Project2_Report.Rmd` and click **Knit → Knit to Word**, or run:

   ```r
   rmarkdown::render("Project2_Report.Rmd", output_format = "word_document")
   ```

5. The generated `Project2_Report.docx` contains the tables, plots, and interpretations. The processed daily dataset is saved in `output/`.

## Author and date

Author: Haiyi Xiong
Prepared: November 8, 2026
