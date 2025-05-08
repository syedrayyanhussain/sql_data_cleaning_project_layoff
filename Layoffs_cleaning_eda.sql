Use world_layoffs

-- -------------------------------------
-- STEP 1: Create a Staging Table for Cleaning
-- -------------------------------------

USE world_layoffs;

-- Create a staging table to avoid modifying the original data
CREATE TABLE layoffs_staging LIKE layoffs;

-- Insert all data from the original table into the staging table
INSERT INTO layoffs_staging
SELECT * FROM layoffs;

SELECT * FROM layoffs_staging;


-- -------------------------------------
-- STEP 2: Remove Duplicate Records
-- -------------------------------------

-- Check for duplicates using ROW_NUMBER()
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry, total_laid_off, 
                            percentage_laid_off, `date`, stage, country, funds_raised_millions
               ORDER BY company
           ) AS row_num
    FROM layoffs_staging
)
-- Create a cleaned staging table without duplicates
CREATE TABLE layoffs_staging2 (
  company TEXT,
  location TEXT,
  industry TEXT,
  total_laid_off INT DEFAULT NULL,
  percentage_laid_off TEXT,
  `date` TEXT,
  stage TEXT,
  country TEXT,
  funds_raised_millions INT DEFAULT NULL,
  row_num INT
);

-- Insert cleaned data (removing duplicates)
INSERT INTO layoffs_staging2
SELECT *, 
       ROW_NUMBER() OVER (
           PARTITION BY company, location, industry, total_laid_off, 
                        percentage_laid_off, `date`, stage, country, funds_raised_millions
           ORDER BY company
       ) AS row_num
FROM layoffs_staging;

-- Delete duplicate rows where row_num > 1
DELETE FROM layoffs_staging2
WHERE row_num > 1;

SELECT * FROM layoffs_staging2;


-- -------------------------------------
-- STEP 3: Standardize Data
-- -------------------------------------

-- Remove extra spaces from company names
UPDATE layoffs_staging2
SET company = TRIM(company);

-- Standardize "Crypto" industry naming
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Standardize country names
UPDATE layoffs_staging2 
SET country = 'United States'
WHERE country LIKE 'United States.';

-- Convert `date` column to proper DATE format
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Alter the column type
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- -------------------------------------
-- STEP 4: Handle NULL or Blank Values
-- -------------------------------------

-- Set empty industry values to NULL
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Try to fill missing industries based on other rows with same company & location
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

-- Check rows with both layoffs values missing
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;


-- -------------------------------------
-- STEP 5: Final Cleanup
-- -------------------------------------

-- Drop row_num column as it's no longer needed
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT * FROM layoffs_staging2;


-- -------------------------------------
-- STEP 6: Exploratory Data Analysis (EDA)
-- -------------------------------------

-- 1. Companies with 100% layoff
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- 2. Total layoffs by company
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC;

-- 3. Total layoffs by industry
SELECT industry, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_laid_off DESC;

-- 4. Total layoffs by country
SELECT country, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY country
ORDER BY total_laid_off DESC;

-- 5. Total layoffs by year
SELECT YEAR(`date`) AS year, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY year DESC;

-- 6. Total layoffs by funding stage
SELECT stage, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY stage
ORDER BY total_laid_off DESC;
