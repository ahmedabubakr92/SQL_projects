-- First, Creating a database to import the call center data into
CREATE DATABASE call_center_project;

-- Next, selecting the database we want to work with
USE call_center_project;

-- Creating a table that will contain the csv file I want to import
CREATE TABLE calls (
	ID CHAR(50),
    cust_name CHAR(50),
    sentiment CHAR(20),
    csat_score INT,
    call_timestamp CHAR(10),
    reason CHAR(20),
    city CHAR(20),
    state CHAR(20),
    channel CHAR(20),
    response_time CHAR(20),
    call_duration_minutes INT,
    call_center CHAR(20)
);
--  Using the "Table Data Import Wizard" to populate "calls" table

-- To make sure everything went smoothly, let's take a look at the table
SELECT * FROM calls LIMIT 10;

-- The call_timestamp is a string, I'll convert it into a date
SET SQL_SAFE_UPDATES = 0;

UPDATE calls SET call_timestamp = str_to_date(call_timestamp, "%m/%d/%Y");

SET SQL_SAFE_UPDATES = 1;

SELECT * FROM calls LIMIT 10;

-- The csat_score values that are 0 will be replaced with NULL as 1 is the only minimum values
SET SQL_SAFE_UPDATES = 0;

UPDATE calls
SET csat_score = NULL
WHERE csat_score = 0;

SET SQL_SAFE_UPDATES = 1;

SELECT * FROM calls LIMIT 10;

-- Let's check the shape of the data, i.e., the number of rows and columns
SELECT COUNT(*) AS rows_num FROM calls;
SELECT COUNT(*) AS cols_num FROM information_schema.columns WHERE table_name = 'calls';

-- Checking the distinct values of some columns:
SELECT DISTINCT sentiment FROM calls;
SELECT DISTINCT reason FROM calls;
SELECT DISTINCT channel FROM calls;
SELECT DISTINCT response_time FROM calls;
SELECT DISTINCT call_center FROM calls;

-- The count and percentage of the total of each of the distnict values in each of these columns
SELECT sentiment, COUNT(*), ROUND(COUNT(*) / (SELECT COUNT(*) FROM calls) * 100, 1) AS pct FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT reason, COUNT(*), ROUND(COUNT(*) / (SELECT COUNT(*) FROM calls) * 100, 1) AS pct FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT channel, COUNT(*), ROUND(COUNT(*) / (SELECT COUNT(*) FROM calls) * 100, 1) AS pct FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT response_time, COUNT(*), ROUND(COUNT(*) / (SELECT COUNT(*) FROM calls) * 100, 1) AS pct FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT call_center, COUNT(*), ROUND(COUNT(*) / (SELECT COUNT(*) FROM calls) * 100, 1) AS pct FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT state, COUNT(*), ROUND(COUNT(*) / (SELECT COUNT(*) FROM calls) * 100, 1) AS pct FROM calls GROUP BY 1 ORDER BY 3 DESC;

--  Which day has the most calls:
SELECT DAYNAME(call_timestamp) AS Day_of_call, COUNT(*) AS Num_of_calls FROM calls GROUP BY 1 ORDER BY 2 DESC;

-- Aggregations
SELECT MIN(csat_score) AS Min_score, MAX(csat_score) AS Max_score, ROUND(AVG(csat_score), 1) AS Avg_score FROM calls;

SELECT MIN(call_timestamp) AS earliest_date, MAX(call_timestamp) AS most_recent FROM calls;

SELECT MIN(call_duration_minutes) AS min_call_duration, MAX(call_duration_minutes) AS max_call_duration, 
AVG(call_duration_minutes) AS avg_call_duration FROM calls;

SELECT call_center, response_time, COUNT(*) AS count FROM calls GROUP BY 1, 2 ORDER BY 3 DESC;


SELECT call_center, AVG(call_duration_minutes) AS avg_call_duration FROM calls GROUP BY 1 ORDER BY 2 DESC;

SELECT channel, AVG(call_duration_minutes) AS avg_call_duration FROM calls GROUP BY 1 ORDER BY 2 DESC;

SELECT state, COUNT(*) AS count FROM calls GROUP BY 1 ORDER BY 2 DESC;

SELECT state, reason, COUNT(*) AS count FROM calls GROUP BY 1, 2 ORDER BY 1, 2, 3 DESC;

SELECT state, sentiment, COUNT(*) AS count FROM calls GROUP BY 1, 2 ORDER BY 1, 3 DESC;

SELECT state, AVG(csat_score) AS avg_csat_score FROM calls GROUP BY 1 ORDER BY 2 DESC;

SELECT sentiment, AVG(call_dUration_minutes) AS avg_call_druation FROM calls GROUP BY 1 ORDER BY 2 DESC;
