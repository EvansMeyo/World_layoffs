# World_layoffs
_**MySQL Data Cleaning:** 
Workforce Layoffs (2020-2022) 
This project focuses on cleaning and preparing a dataset of workforce layoffs that occurred between 2020 and 2022 using MySQL. The primary objective is to transform raw data into a structured format suitable for analysis.
Steps Involved:

**Data Importation:**

Load raw data files into MySQL tables using the LOAD DATA INFILE command.
Data Validation:

**Validate data types for each column  (e.g., ensuring dates are in YYYY-MM-DD format).**
Check for missing values and outliers using SELECT queries and conditional statements.
Data Cleaning:

**Remove duplicate entries with DELETE statements.**
Correct inconsistent data entries, such as standardizing company names and job titles using UPDATE queries.
Handle missing values by either imputing with appropriate measures or removing the affected rows.
Data Transformation:

Normalize data where necessary by creating separate tables for entities like companies and locations, then establishing foreign key relationships.
Aggregate data to derive meaningful insights, such as total layoffs per company or industry.

**Data Exportation:**
Export the cleaned data into a new table or CSV file.

**Tools and Technologies:**
MySQL for database management and query execution.
SQL scripts for performing data cleaning operations.
