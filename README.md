# 🧹 SQL Data Cleaning & Exploratory Data Analysis (EDA)

This project focuses on cleaning and analyzing a dataset of global layoffs using SQL. The dataset includes information about layoffs by various companies over time. The objective is to clean messy data and perform exploratory data analysis (EDA) to draw insights.

---

## 📌 Project Goals

- Remove duplicates from raw data
- Standardize inconsistent entries (e.g., industry, country names)
- Handle null or missing values
- Convert string dates to SQL `DATE` format
- Perform basic exploratory analysis:
  - Total layoffs by company, industry, country, and year
  - Identify companies with 100% layoffs
  - Analyze layoffs by funding stage

---

## 🗃 Dataset

- **Table Name:** `layoffs`
- **Source:** [Alex The Analyst YouTube SQL Project](https://github.com/AlexTheAnalyst/MySQL-YouTube-Series)  
- **Fields Included:**
  - company, location, industry
  - total_laid_off, percentage_laid_off
  - date, stage, country, funds_raised_millions

---

## 🛠 Tools Used

- MySQL (or any SQL-compatible RDBMS)
- SQL queries for data wrangling and aggregation

---

## 📄 Process Overview

### 1. 🧪 Staging the Data
Create a duplicate of the original table (`layoffs_staging`) to avoid affecting the raw data.

### 2. 🧯 Removing Duplicates
Used `ROW_NUMBER()` and `DELETE` strategy to retain only unique rows.

### 3. ✨ Standardizing Entries
- Trim extra spaces from company names
- Normalize industry and country names
- Convert `date` string to SQL `DATE` type

### 4. 🧼 Handling Nulls and Blanks
- Replaced blank `industry` entries with `NULL`
- Used self-join to fill missing `industry` values based on matching company/location

### 5. 📊 Exploratory Data Analysis
- Total layoffs grouped by company, industry, country, and funding stage
- Yearly trends of layoffs
- Identified companies with full (100%) layoffs

---

## 📈 Sample Insights

- Top companies by number of layoffs
- Industries most affected by layoffs
- Countries with the highest layoffs
- Layoffs trend over the years

---

## 📂 Project Files

- `layoffs_cleaning_eda.sql`: All SQL queries used for cleaning and analysis
- `README.md`: Documentation and explanation of the project

---

## 👤 Author
 
- Based on [Alex The Analyst's SQL Project Series](https://www.youtube.com/@AlexTheAnalyst)

---

## 📝 License

This project is for educational and personal portfolio use. Dataset and base idea credit to Alex the Analyst.

