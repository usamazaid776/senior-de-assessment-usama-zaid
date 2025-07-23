
ETL Pipeline - Currency Conversion & Validation
===============================================

This project is an ETL (Extract, Transform, Load) pipeline built using PySpark that:

- Loads sales and product reference data.
- Cleans and validates the data.
- Converts currency to USD using a live or fallback exchange rate API.
- Logs the conversion details.
- Handles errors and aborts if the failure threshold is exceeded.
- Writes clean, log, and error data to a MySQL database.

-----------------------------------------------
TABLE OF CONTENTS
-----------------------------------------------

1. Project Structure
2. Prerequisites
3. Installation
4. Input Files
5. Execution
6. ETL Pipeline Breakdown
7. Output Tables
8. Error Handling
9. Notes

-----------------------------------------------
1. Project Structure
-----------------------------------------------

.
├── etl_pipeline.py              # Main ETL script
├── README.txt                   # Project documentation (this file)
└── sample_data/
    ├── sales_data.csv           # Input sales data
    └── product_reference.csv    # Input product reference data

-----------------------------------------------
2. Prerequisites
-----------------------------------------------

Make sure the following are installed:

- Python 3.7+
- Java 8 or higher
- Apache Spark
- PySpark
- MySQL (local or remote)
- MySQL JDBC Driver (`mysql-connector-j-*.jar`)
- pandas
- requests

-----------------------------------------------
3. Installation
-----------------------------------------------

Install required packages:

    pip install pyspark pandas requests

Download the MySQL JDBC Driver from:
    https://dev.mysql.com/downloads/connector/j/

Place the downloaded `.jar` file at:
    /content/sample_data/mysql-connector-j-9.3.0.jar

-----------------------------------------------
4. Input Files
-----------------------------------------------

Place the following CSV files inside `/content/sample_data/`:

- sales_data.csv
- product_reference.csv

-----------------------------------------------
5. Execution
-----------------------------------------------

Run the script using:

    python etl_pipeline.py

Ensure Spark and MySQL configurations are correct.

-----------------------------------------------
6. ETL Pipeline Breakdown
-----------------------------------------------

Step 1: Initialize Spark
- Configures Spark session and sets JDBC driver path.

Step 2: Load Input Data
- Reads both sales and product reference CSVs into DataFrames.

Step 3: Clean Data
- Drops duplicate records.
- Drops rows with nulls in "SaleAmount", "ProductID", or "Currency".

Step 4: Validate Reference Data
- Inner join on `ProductID` to filter valid sales.

Step 5: Currency Conversion
- Fetches exchange rates from: https://api.exchangerate-api.com/v4/latest/EUR
- Uses fallback rates if API fails:
    USD: 1.16
    GBP: 0.867
    EUR: 1.0
- Converts sale amount to USD via Spark UDF.

Step 6: Conversion Logging
- Logs conversion details:
    - Order ID
    - Original Currency
    - Converted USD Value
    - Timestamp
    - Rate used
    - Source (Live/Fallback)

Step 7: Error Handling
- Filters failed currency conversions.
- Aborts if >5% of records failed conversion.

Step 8: Write to MySQL
- JDBC URL: jdbc:mysql://sql12.freesqldatabase.com:3306/sql12791174
- Writes to three tables:
    - final_cleaned_sales
    - conversion_log
    - rejected_records

-----------------------------------------------
7. Output Tables
-----------------------------------------------

| Table Name           | Description                          |
|----------------------|--------------------------------------|
| final_cleaned_sales  | Successfully cleaned & converted     |
| conversion_log       | Conversion rate and timestamp info   |
| rejected_records     | Rows where currency conversion failed|

MySQL Credentials:

- Host:     sql12.freesqldatabase.com
- Port:     3306
- Database: sql12791174
- User:     sql12791174
- Password: ehfTsN1yXX

-----------------------------------------------
8. Error Handling
-----------------------------------------------

- If `SaleAmount_USD` is null after conversion, the record is flagged as an error.
- If error rate > 5%, pipeline raises exception and stops.

-----------------------------------------------
9. Notes
-----------------------------------------------

- This code is written for use in a Google Colab or similar environment.
- Modify file paths if running in a local environment.
- API timeout is 5 seconds.
- You can customize fallback rates if needed.
- Ensure network access to MySQL host is allowed.

-----------------------------------------------
Author: Usama Zaid
Project Name: ETL_Assessment_UsamaZaid
-----------------------------------------------

