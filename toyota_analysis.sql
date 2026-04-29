create database toyota_stock;

-- 1. How many rows?--
SELECT COUNT(*) FROM toyota_stock_1980_2025;

-- 2. What does the data look like?--
SELECT * FROM toyota_stock_1980_2025 LIMIT 5;

-- 3. What is the date range?--
SELECT MIN(Date) AS earliest, MAX(Date) AS latest 
FROM toyota_stock_1980_2025;

-- 4. What are the column types?--
DESCRIBE toyota_stock_1980_2025;

-- we need to fix the data types. Run these queries:
ALTER TABLE toyota_stock_1980_2025
MODIFY COLUMN Date DATE,
MODIFY COLUMN Open DOUBLE,
MODIFY COLUMN High DOUBLE,
MODIFY COLUMN Low DOUBLE,
MODIFY COLUMN Close DOUBLE,
MODIFY COLUMN Adj_Close DOUBLE,
MODIFY COLUMN Volume BIGINT;

DESCRIBE toyota_stock_1980_2025;

-- What is the overall price history — min, max and average closing price across 45 years?--
SELECT 
    MIN(Close) AS lowest_price_ever,
    MAX(Close) AS highest_price_ever,
    ROUND(AVG(Close), 2) AS average_price,
    MIN(Date) AS from_date,
    MAX(Date) AS to_date
FROM toyota_stock_1980_2025;

-- Which year had the highest average stock price?--
SELECT 
    YEAR(Date) AS year,
    ROUND(AVG(Close), 2) AS avg_price,
    ROUND(MAX(High), 2) AS highest_price,
    ROUND(MIN(Low), 2) AS lowest_price
FROM toyota_stock_1980_2025
GROUP BY YEAR(Date)
ORDER BY avg_price DESC
LIMIT 10;


-- How did the 2008 financial crisis affect Toyota?--
SELECT 
    YEAR(Date) AS year,
    ROUND(AVG(Close), 2) AS avg_price,
    ROUND(MIN(Low), 2) AS lowest_price
FROM toyota_stock_1980_2025
WHERE YEAR(Date) BETWEEN 2006 AND 2012
GROUP BY YEAR(Date)
ORDER BY YEAR(Date);

 -- add a calculated column — daily price change — to measure how volatile the stock is day to day
 ALTER TABLE toyota_stock_1980_2025
ADD COLUMN Daily_Range DOUBLE;

UPDATE toyota_stock_1980_2025
SET Daily_Range = ROUND(High - Low, 4);

SELECT Date, High, Low, Daily_Range 
FROM toyota_stock_1980_2025 
LIMIT 5;

-- check recent years where the stock is worth $200+
SELECT 
    YEAR(Date) AS year,
    ROUND(AVG(Daily_Range), 2) AS avg_daily_range,
    ROUND(MAX(Daily_Range), 2) AS biggest_single_day_swing
FROM toyota_stock_1980_2025
GROUP BY YEAR(Date)
ORDER BY avg_daily_range DESC
LIMIT 10;

--  Any missing values?--
SELECT 
    SUM(CASE WHEN Close IS NULL THEN 1 ELSE 0 END) AS missing_close,
    SUM(CASE WHEN Volume IS NULL THEN 1 ELSE 0 END) AS missing_volume,
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS missing_dates
FROM toyota_stock_1980_2025;

--  Any zero prices?--
SELECT COUNT(*) AS zero_prices
FROM toyota_stock_1980_2025
WHERE Close = 0 OR Open = 0;