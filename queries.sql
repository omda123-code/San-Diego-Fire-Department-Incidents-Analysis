use [Fire San diego]
select * from fd_incidents_2020
select * from fd_incidents_2021
select * from fd_incidents_2022
select * from fd_incidents_2023
select * from fd_incidents_2024
select * from fd_incidents_2025


-- Question: What is the total number of fire incidents reported each year from 2020 to 2025?
-- Purpose: To understand year-over-year trends in fire incident volume.

SELECT 
    year_response AS Year, 
    COUNT(*) AS Total_Incidents
FROM (
    SELECT year_response FROM fd_incidents_2020
    UNION ALL SELECT year_response FROM fd_incidents_2021
    UNION ALL SELECT year_response FROM fd_incidents_2022
    UNION ALL SELECT year_response FROM fd_incidents_2023
    UNION ALL SELECT year_response FROM fd_incidents_2024
    UNION ALL SELECT year_response FROM fd_incidents_2025
) AS AllData
GROUP BY year_response
ORDER BY year_response;


-- Question: Which months experience the highest number of fire incidents across all years?
-- Purpose: To identify seasonal trends in fire activity.

SELECT 
    month_response AS Month, 
    COUNT(*) AS Total_Incidents
FROM (
    SELECT month_response FROM fd_incidents_2020
    UNION ALL SELECT month_response FROM fd_incidents_2021
    UNION ALL SELECT month_response FROM fd_incidents_2022
    UNION ALL SELECT month_response FROM fd_incidents_2023
    UNION ALL SELECT month_response FROM fd_incidents_2024
    UNION ALL SELECT month_response FROM fd_incidents_2025
) AS AllData
GROUP BY month_response
ORDER BY Total_Incidents DESC;


-- Question: What are the top 5 ZIP codes with the highest number of incidents?
-- Purpose: To locate the most fire-prone neighborhoods.

SELECT 
    address_zip, 
    COUNT(*) AS Total_Incidents
FROM (
    SELECT address_zip FROM fd_incidents_2020
    UNION ALL SELECT address_zip FROM fd_incidents_2021
    UNION ALL SELECT address_zip FROM fd_incidents_2022
    UNION ALL SELECT address_zip FROM fd_incidents_2023
    UNION ALL SELECT address_zip FROM fd_incidents_2024
    UNION ALL SELECT address_zip FROM fd_incidents_2025
) AS AllData
GROUP BY address_zip
ORDER BY Total_Incidents DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;


-- Question: Which call categories are most common overall?
-- Purpose: To identify which types of responses dominate incident activity.

SELECT 
    call_category, 
    COUNT(*) AS Total_Incidents
FROM (
    SELECT call_category FROM fd_incidents_2020
    UNION ALL SELECT call_category FROM fd_incidents_2021
    UNION ALL SELECT call_category FROM fd_incidents_2022
    UNION ALL SELECT call_category FROM fd_incidents_2023
    UNION ALL SELECT call_category FROM fd_incidents_2024
    UNION ALL SELECT call_category FROM fd_incidents_2025
) AS AllData
GROUP BY call_category
ORDER BY Total_Incidents DESC;


-- Question: Which year had the highest number of Life-Threatening Emergency Response incidents?
-- Purpose: To evaluate high-severity incident patterns.

SELECT 
    year_response, 
    COUNT(*) AS LifeThreat_Incidents
FROM (
    SELECT year_response, call_category FROM fd_incidents_2020
    UNION ALL SELECT year_response, call_category FROM fd_incidents_2021
    UNION ALL SELECT year_response, call_category FROM fd_incidents_2022
    UNION ALL SELECT year_response, call_category FROM fd_incidents_2023
    UNION ALL SELECT year_response, call_category FROM fd_incidents_2024
    UNION ALL SELECT year_response, call_category FROM fd_incidents_2025
) AS AllData
WHERE call_category = 'Life-Threatening Emergency Response'
GROUP BY year_response
ORDER BY LifeThreat_Incidents DESC;


-- Question: What are the top 3 most frequent “problems” reported across all years?
-- Purpose: To discover recurring operational issues.

SELECT TOP 3
    problem,
    COUNT(*) AS Frequency
FROM (
    SELECT problem FROM fd_incidents_2020
    UNION ALL SELECT problem FROM fd_incidents_2021
    UNION ALL SELECT problem FROM fd_incidents_2022
    UNION ALL SELECT problem FROM fd_incidents_2023
    UNION ALL SELECT problem FROM fd_incidents_2024
    UNION ALL SELECT problem FROM fd_incidents_2025
) AS AllData
GROUP BY problem
ORDER BY Frequency DESC;


-- Question: How many incidents occurred on each day of the week (based on date_response)?
-- Purpose: To analyze workload distribution by weekday.

SELECT 
    DATENAME(WEEKDAY, date_response) AS DayOfWeek,
    COUNT(*) AS Total_Incidents
FROM (
    SELECT date_response FROM fd_incidents_2020
    UNION ALL SELECT date_response FROM fd_incidents_2021
    UNION ALL SELECT date_response FROM fd_incidents_2022
    UNION ALL SELECT date_response FROM fd_incidents_2023
    UNION ALL SELECT date_response FROM fd_incidents_2024
    UNION ALL SELECT date_response FROM fd_incidents_2025
) AS AllData
GROUP BY DATENAME(WEEKDAY, date_response)
ORDER BY Total_Incidents DESC;


-- Question: What percentage of total incidents were “Life-Threatening” each year?
-- Purpose: To assess yearly severity ratios.

WITH AllData AS (
    SELECT year_response, call_category FROM fd_incidents_2020
    UNION ALL SELECT year_response, call_category FROM fd_incidents_2021
    UNION ALL SELECT year_response, call_category FROM fd_incidents_2022
    UNION ALL SELECT year_response, call_category FROM fd_incidents_2023
    UNION ALL SELECT year_response, call_category FROM fd_incidents_2024
    UNION ALL SELECT year_response, call_category FROM fd_incidents_2025
)
SELECT 
    year_response,
    COUNT(CASE WHEN call_category = 'Life-Threatening Emergency Response' THEN 1 END) * 100.0 / COUNT(*) AS LifeThreat_Pct
FROM AllData
GROUP BY year_response
ORDER BY year_response;


-- Question: How many incidents happened per jurisdiction?
-- Purpose: To evaluate distribution of calls between city jurisdictions.

SELECT 
    jurisdiction,
    COUNT(*) AS Total_Incidents
FROM (
    SELECT jurisdiction FROM fd_incidents_2020
    UNION ALL SELECT jurisdiction FROM fd_incidents_2021
    UNION ALL SELECT jurisdiction FROM fd_incidents_2022
    UNION ALL SELECT jurisdiction FROM fd_incidents_2023
    UNION ALL SELECT jurisdiction FROM fd_incidents_2024
    UNION ALL SELECT jurisdiction FROM fd_incidents_2025
) AS AllData
GROUP BY jurisdiction
ORDER BY Total_Incidents DESC;


-- Question: Which ZIP code had the fastest increase in incidents between 2020 and 2025?
-- Purpose: To detect emerging high-risk areas.

WITH Combined AS (
    SELECT address_zip, year_response FROM fd_incidents_2020
    UNION ALL SELECT address_zip, year_response FROM fd_incidents_2021
    UNION ALL SELECT address_zip, year_response FROM fd_incidents_2022
    UNION ALL SELECT address_zip, year_response FROM fd_incidents_2023
    UNION ALL SELECT address_zip, year_response FROM fd_incidents_2024
    UNION ALL SELECT address_zip, year_response FROM fd_incidents_2025
)
SELECT 
    address_zip,
    SUM(CASE WHEN year_response = 2020 THEN 1 ELSE 0 END) AS Incidents_2020,
    SUM(CASE WHEN year_response = 2025 THEN 1 ELSE 0 END) AS Incidents_2025,
    (SUM(CASE WHEN year_response = 2025 THEN 1 ELSE 0 END) -
     SUM(CASE WHEN year_response = 2020 THEN 1 ELSE 0 END)) AS Increase
FROM Combined
GROUP BY address_zip
ORDER BY Increase DESC;


-- Question: On average, how many incidents occur per day?
-- Purpose: To estimate daily operational workload.

SELECT 
    COUNT(*) * 1.0 / COUNT(DISTINCT CAST(date_response AS DATE)) AS Avg_Incidents_Per_Day
FROM (
    SELECT date_response FROM fd_incidents_2020
    UNION ALL SELECT date_response FROM fd_incidents_2021
    UNION ALL SELECT date_response FROM fd_incidents_2022
    UNION ALL SELECT date_response FROM fd_incidents_2023
    UNION ALL SELECT date_response FROM fd_incidents_2024
    UNION ALL SELECT date_response FROM fd_incidents_2025
) AS AllData;


-- Question: What’s the distribution of incidents by time of day (hour)?
-- Purpose: To analyze when most emergencies occur.

SELECT 
    DATEPART(HOUR, date_response) AS HourOfDay,
    COUNT(*) AS Total_Incidents
FROM (
    SELECT date_response FROM fd_incidents_2020
    UNION ALL SELECT date_response FROM fd_incidents_2021
    UNION ALL SELECT date_response FROM fd_incidents_2022
    UNION ALL SELECT date_response FROM fd_incidents_2023
    UNION ALL SELECT date_response FROM fd_incidents_2024
    UNION ALL SELECT date_response FROM fd_incidents_2025
) AS AllData
GROUP BY DATEPART(HOUR, date_response)
ORDER BY HourOfDay;


-- Question: What’s the ratio of medical vs non-medical fire incidents?
-- Purpose: To understand operational balance between medical and fire-only responses.

WITH AllData AS (
    SELECT call_category FROM fd_incidents_2020
    UNION ALL SELECT call_category FROM fd_incidents_2021
    UNION ALL SELECT call_category FROM fd_incidents_2022
    UNION ALL SELECT call_category FROM fd_incidents_2023
    UNION ALL SELECT call_category FROM fd_incidents_2024
    UNION ALL SELECT call_category FROM fd_incidents_2025
)
SELECT 
    SUM(CASE WHEN call_category LIKE '%Medical%' THEN 1 ELSE 0 END) AS Medical,
    SUM(CASE WHEN call_category NOT LIKE '%Medical%' THEN 1 ELSE 0 END) AS NonMedical
FROM AllData;


-- Question: How many incidents happen in December each year?
-- Purpose: To explore holiday-season fire trends.

SELECT 
    year_response,
    COUNT(*) AS December_Incidents
FROM (
    SELECT month_response, year_response FROM fd_incidents_2020
    UNION ALL SELECT month_response, year_response FROM fd_incidents_2021
    UNION ALL SELECT month_response, year_response FROM fd_incidents_2022
    UNION ALL SELECT month_response, year_response FROM fd_incidents_2023
    UNION ALL SELECT month_response, year_response FROM fd_incidents_2024
    UNION ALL SELECT month_response, year_response FROM fd_incidents_2025
) AS AllData
WHERE month_response = 12
GROUP BY year_response
ORDER BY year_response;


-- Question: What’s the cumulative number of fire incidents up to each year (2020–2025)?
-- Purpose: To measure total response volume growth over time.

WITH Yearly AS (
    SELECT year_response, COUNT(*) AS Year_Count
    FROM (
        SELECT year_response FROM fd_incidents_2020
        UNION ALL SELECT year_response FROM fd_incidents_2021
        UNION ALL SELECT year_response FROM fd_incidents_2022
        UNION ALL SELECT year_response FROM fd_incidents_2023
        UNION ALL SELECT year_response FROM fd_incidents_2024
        UNION ALL SELECT year_response FROM fd_incidents_2025
    ) AS AllData
    GROUP BY year_response
)
SELECT 
    year_response,
    SUM(Year_Count) OVER (ORDER BY year_response) AS Cumulative_Incidents
FROM Yearly;


-- Question: Which ZIP codes consistently show high incident rates every year?
-- Purpose: To identify persistently high-risk areas requiring long-term mitigation.

WITH AllData AS (
    SELECT address_zip, year_response FROM fd_incidents_2020
    UNION ALL SELECT address_zip, year_response FROM fd_incidents_2021
    UNION ALL SELECT address_zip, year_response FROM fd_incidents_2022
    UNION ALL SELECT address_zip, year_response FROM fd_incidents_2023
    UNION ALL SELECT address_zip, year_response FROM fd_incidents_2024
    UNION ALL SELECT address_zip, year_response FROM fd_incidents_2025
)
SELECT 
    address_zip,
    COUNT(DISTINCT year_response) AS Active_Years,
    COUNT(*) AS Total_Incidents
FROM AllData
GROUP BY address_zip
HAVING COUNT(DISTINCT year_response) = 6
ORDER BY Total_Incidents DESC;


-- Question: Which months had the largest year-over-year percentage increase in incidents?
-- Purpose: To pinpoint unusual seasonal surges.

WITH Monthly AS (
    SELECT year_response, month_response, COUNT(*) AS Total
    FROM (
        SELECT year_response, month_response FROM fd_incidents_2020
        UNION ALL SELECT year_response, month_response FROM fd_incidents_2021
        UNION ALL SELECT year_response, month_response FROM fd_incidents_2022
        UNION ALL SELECT year_response, month_response FROM fd_incidents_2023
        UNION ALL SELECT year_response, month_response FROM fd_incidents_2024
        UNION ALL SELECT year_response, month_response FROM fd_incidents_2025
    ) AS AllData
    GROUP BY year_response, month_response
)
SELECT 
    year_response, month_response,
    Total,
    LAG(Total) OVER (PARTITION BY month_response ORDER BY year_response) AS Prev_Year,
    (Total - LAG(Total) OVER (PARTITION BY month_response ORDER BY year_response)) * 100.0 /
     NULLIF(LAG(Total) OVER (PARTITION BY month_response ORDER BY year_response), 0) AS YoY_Change_Percent
FROM Monthly
ORDER BY YoY_Change_Percent DESC;


-- Question: What are the top 10 days with the highest number of incidents (across all years)?
-- Purpose: To identify peak emergency days for resource planning.

SELECT TOP 10 
    CAST(date_response AS DATE) AS Incident_Date,
    COUNT(*) AS Total_Incidents
FROM (
    SELECT date_response FROM fd_incidents_2020
    UNION ALL SELECT date_response FROM fd_incidents_2021
    UNION ALL SELECT date_response FROM fd_incidents_2022
    UNION ALL SELECT date_response FROM fd_incidents_2023
    UNION ALL SELECT date_response FROM fd_incidents_2024
    UNION ALL SELECT date_response FROM fd_incidents_2025
) AS AllData
GROUP BY CAST(date_response AS DATE)
ORDER BY Total_Incidents DESC;


-- Question: What are the most common problems per call category?
-- Purpose: To identify typical causes or scenarios within each response type.

WITH AllData AS (
    SELECT call_category, problem FROM fd_incidents_2020
    UNION ALL SELECT call_category, problem FROM fd_incidents_2021
    UNION ALL SELECT call_category, problem FROM fd_incidents_2022
    UNION ALL SELECT call_category, problem FROM fd_incidents_2023
    UNION ALL SELECT call_category, problem FROM fd_incidents_2024
    UNION ALL SELECT call_category, problem FROM fd_incidents_2025
)
SELECT 
    call_category,
    problem,
    COUNT(*) AS Count_Problem,
    RANK() OVER (PARTITION BY call_category ORDER BY COUNT(*) DESC) AS RankByCategory
FROM AllData
GROUP BY call_category, problem
HAVING COUNT(*) > 1
ORDER BY call_category, RankByCategory;


-- Question: How do incident counts vary between weekdays and weekends?
-- Purpose: To see if weekends have higher or lower emergency rates.

SELECT 
    CASE 
        WHEN DATENAME(WEEKDAY, date_response) IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END AS DayType,
    COUNT(*) AS Total_Incidents
FROM (
    SELECT date_response FROM fd_incidents_2020
    UNION ALL SELECT date_response FROM fd_incidents_2021
    UNION ALL SELECT date_response FROM fd_incidents_2022
    UNION ALL SELECT date_response FROM fd_incidents_2023
    UNION ALL SELECT date_response FROM fd_incidents_2024
    UNION ALL SELECT date_response FROM fd_incidents_2025
) AS AllData
GROUP BY CASE 
        WHEN DATENAME(WEEKDAY, date_response) IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END;


-- Question: What’s the monthly average number of incidents per year?
-- Purpose: To normalize monthly comparisons across years.

WITH AllData AS (
    SELECT year_response, month_response FROM fd_incidents_2020
    UNION ALL SELECT year_response, month_response FROM fd_incidents_2021
    UNION ALL SELECT year_response, month_response FROM fd_incidents_2022
    UNION ALL SELECT year_response, month_response FROM fd_incidents_2023
    UNION ALL SELECT year_response, month_response FROM fd_incidents_2024
    UNION ALL SELECT year_response, month_response FROM fd_incidents_2025
)
SELECT 
    year_response,
    AVG(COUNT(*)) OVER (PARTITION BY year_response) AS Avg_Incidents_Per_Month
FROM AllData
GROUP BY year_response, month_response
ORDER BY year_response;


-- Question: What proportion of incidents occur within each “call_category” per year?
-- Purpose: To evaluate the operational composition over time.

WITH AllData AS (
    SELECT year_response, call_category FROM fd_incidents_2020
    UNION ALL SELECT year_response, call_category FROM fd_incidents_2021
    UNION ALL SELECT year_response, call_category FROM fd_incidents_2022
    UNION ALL SELECT year_response, call_category FROM fd_incidents_2023
    UNION ALL SELECT year_response, call_category FROM fd_incidents_2024
    UNION ALL SELECT year_response, call_category FROM fd_incidents_2025
)
SELECT 
    year_response,
    call_category,
    COUNT(*) AS Total,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY year_response), 2) AS PctOfYear
FROM AllData
GROUP BY year_response, call_category
ORDER BY year_response, PctOfYear DESC;


-- Question: How many incidents per ZIP code occur for each call_category?
-- Purpose: To cross-analyze geography and incident type.

WITH AllData AS (
    SELECT address_zip, call_category FROM fd_incidents_2020
    UNION ALL SELECT address_zip, call_category FROM fd_incidents_2021
    UNION ALL SELECT address_zip, call_category FROM fd_incidents_2022
    UNION ALL SELECT address_zip, call_category FROM fd_incidents_2023
    UNION ALL SELECT address_zip, call_category FROM fd_incidents_2024
    UNION ALL SELECT address_zip, call_category FROM fd_incidents_2025
)
SELECT 
    address_zip,
    call_category,
    COUNT(*) AS Incidents
FROM AllData
GROUP BY address_zip, call_category
ORDER BY address_zip, Incidents DESC;


-- Question: What are the top 5 “problems” that appear only in 2025 but never before?
-- Purpose: To detect new or emerging hazard types.

WITH PrevYears AS (
    SELECT DISTINCT problem FROM (
        SELECT problem FROM fd_incidents_2020
        UNION ALL SELECT problem FROM fd_incidents_2021
        UNION ALL SELECT problem FROM fd_incidents_2022
        UNION ALL SELECT problem FROM fd_incidents_2023
        UNION ALL SELECT problem FROM fd_incidents_2024
    ) AS P
),
CurrentYear AS (
    SELECT problem FROM fd_incidents_2025
)
SELECT TOP 5 problem
FROM CurrentYear
WHERE problem NOT IN (SELECT problem FROM PrevYears)
GROUP BY problem
ORDER BY COUNT(*) DESC;


-- Question: Which ZIP codes have the widest variation (volatility) in incident counts across years?
-- Purpose: To identify unstable or emerging risk zones.

WITH Combined AS (
    SELECT address_zip, year_response FROM fd_incidents_2020
    UNION ALL SELECT address_zip, year_response FROM fd_incidents_2021
    UNION ALL SELECT address_zip, year_response FROM fd_incidents_2022
    UNION ALL SELECT address_zip, year_response FROM fd_incidents_2023
    UNION ALL SELECT address_zip, year_response FROM fd_incidents_2024
    UNION ALL SELECT address_zip, year_response FROM fd_incidents_2025
),
YearlyCounts AS (
    SELECT address_zip, year_response, COUNT(*) AS Total
    FROM Combined
    GROUP BY address_zip, year_response
)
SELECT 
    address_zip,
    MAX(Total) - MIN(Total) AS Variation
FROM YearlyCounts
GROUP BY address_zip
ORDER BY Variation DESC;


-- Question: What’s the trend of “HAZARD” incidents by month and year?
-- Purpose: To visualize hazardous response frequency evolution.

SELECT 
    year_response,
    month_response,
    COUNT(*) AS Hazard_Count
FROM (
    SELECT * FROM fd_incidents_2020
    UNION ALL SELECT * FROM fd_incidents_2021
    UNION ALL SELECT * FROM fd_incidents_2022
    UNION ALL SELECT * FROM fd_incidents_2023
    UNION ALL SELECT * FROM fd_incidents_2024
    UNION ALL SELECT * FROM fd_incidents_2025
) AS AllData
WHERE problem = 'HAZARD'
GROUP BY year_response, month_response
ORDER BY year_response, month_response;


-- Question: Are incident frequencies correlated with specific ZIP codes over time?
-- Purpose: To identify consistently active geographic clusters.

SELECT 
    year_response,
    address_zip,
    COUNT(*) AS Total_Incidents
FROM (
    SELECT address_zip, year_response FROM fd_incidents_2020
    UNION ALL SELECT address_zip, year_response FROM fd_incidents_2021
    UNION ALL SELECT address_zip, year_response FROM fd_incidents_2022
    UNION ALL SELECT address_zip, year_response FROM fd_incidents_2023
    UNION ALL SELECT address_zip, year_response FROM fd_incidents_2024
    UNION ALL SELECT address_zip, year_response FROM fd_incidents_2025
) AS AllData
GROUP BY year_response, address_zip
ORDER BY year_response, Total_Incidents DESC;


-- Question: What are the busiest hours per call category?
-- Purpose: To support shift scheduling and dispatch readiness.

SELECT 
    call_category,
    DATEPART(HOUR, date_response) AS Hour,
    COUNT(*) AS Total
FROM (
    SELECT call_category, date_response FROM fd_incidents_2020
    UNION ALL SELECT call_category, date_response FROM fd_incidents_2021
    UNION ALL SELECT call_category, date_response FROM fd_incidents_2022
    UNION ALL SELECT call_category, date_response FROM fd_incidents_2023
    UNION ALL SELECT call_category, date_response FROM fd_incidents_2024
    UNION ALL SELECT call_category, date_response FROM fd_incidents_2025
) AS AllData
GROUP BY call_category, DATEPART(HOUR, date_response)
ORDER BY call_category, Total DESC;


-- Question: How does the total number of incidents in 2025 compare to the 5-year average (2020–2024)?
-- Purpose: To benchmark current-year activity against historical performance.

WITH AllData AS (
    SELECT year_response FROM fd_incidents_2020
    UNION ALL SELECT year_response FROM fd_incidents_2021
    UNION ALL SELECT year_response FROM fd_incidents_2022
    UNION ALL SELECT year_response FROM fd_incidents_2023
    UNION ALL SELECT year_response FROM fd_incidents_2024
    UNION ALL SELECT year_response FROM fd_incidents_2025
),
YearCounts AS (
    SELECT year_response, COUNT(*) AS Total FROM AllData GROUP BY year_response
)
SELECT 
    (SELECT Total FROM YearCounts WHERE year_response = 2025) AS Incidents_2025,
    AVG(CASE WHEN year_response < 2025 THEN Total END) AS Avg_2020_2024,
    (SELECT Total FROM YearCounts WHERE year_response = 2025) -
    AVG(CASE WHEN year_response < 2025 THEN Total END) AS Difference
FROM YearCounts;


-- Question: What is the cumulative monthly trend of incidents across the entire 6-year period?
-- Purpose: To visualize overall growth in operational demand.

WITH Monthly AS (
    SELECT 
        CONCAT(year_response, '-', RIGHT('0' + CAST(month_response AS VARCHAR(2)), 2)) AS YearMonth,
        COUNT(*) AS Total
    FROM (
        SELECT year_response, month_response FROM fd_incidents_2020
        UNION ALL SELECT year_response, month_response FROM fd_incidents_2021
        UNION ALL SELECT year_response, month_response FROM fd_incidents_2022
        UNION ALL SELECT year_response, month_response FROM fd_incidents_2023
        UNION ALL SELECT year_response, month_response FROM fd_incidents_2024
        UNION ALL SELECT year_response, month_response FROM fd_incidents_2025
    ) AS AllData
    GROUP BY year_response, month_response
)
SELECT 
    YearMonth,
    SUM(Total) OVER (ORDER BY YearMonth ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_Total
FROM Monthly
ORDER BY YearMonth;


/* ===============================================================
   🔥 San Diego Fire Incidents (2020–2025)
   Data Consolidation + Feature Engineering for Analysis
   Author: Mohamed Emad
   Purpose: Combine yearly datasets into a unified table with 
            additional analytical columns for Power BI & Python EDA
================================================================= */

-- ✅ Step 1: Create a consolidated dataset for all years
SELECT
    agency_type,               -- Type of responding agency (e.g., Fire)
    call_category,             -- Category of the call (Life-Threatening, Hazard, etc.)
    address_city,              -- City name (mostly San Diego)
    jurisdiction,              -- Jurisdiction zone or authority
    problem,                   -- Nature of the emergency/problem
    date_response,             -- Full timestamp of the response
    address_state,             -- State code (CA)
    address_zip,               -- ZIP code for spatial analysis
    day_response,              -- Day of incident
    month_response,            -- Month of incident
    year_response,             -- Year of incident

    /* -----------------------------------------------------------
       🧩 Derived analytical columns
       Added to support deeper trend, temporal, and category analysis
    ------------------------------------------------------------*/

    DATENAME(WEEKDAY, date_response) AS weekday_name,   -- Day of the week (Monday–Sunday)
    DATEPART(HOUR, date_response) AS hour_of_day,       -- Hour of the day (0–23)
    
    -- Grouping categories into broader analytical buckets
    CASE 
        WHEN call_category LIKE '%Life%' THEN 'Life-Threatening'
        WHEN call_category LIKE '%Non-Life%' THEN 'Non-Life-Threatening'
        WHEN call_category LIKE '%Urgent%' THEN 'Urgent'
        WHEN call_category LIKE '%HAZARD%' THEN 'Hazard'
        ELSE 'Other'
    END AS category_group,
    
    -- Define season from month number (for seasonal trend analysis)
    CASE 
        WHEN month_response IN (12,1,2) THEN 'Winter'
        WHEN month_response IN (3,4,5) THEN 'Spring'
        WHEN month_response IN (6,7,8) THEN 'Summer'
        WHEN month_response IN (9,10,11) THEN 'Autumn'
    END AS season

-- ✅ Step 2: Insert into a new unified table
INTO fd_incidents_all

-- ✅ Step 3: Combine all yearly datasets (2020–2025)
FROM (
    SELECT * FROM fd_incidents_2020
    UNION ALL SELECT * FROM fd_incidents_2021
    UNION ALL SELECT * FROM fd_incidents_2022
    UNION ALL SELECT * FROM fd_incidents_2023
    UNION ALL SELECT * FROM fd_incidents_2024
    UNION ALL SELECT * FROM fd_incidents_2025
) AS combined;


