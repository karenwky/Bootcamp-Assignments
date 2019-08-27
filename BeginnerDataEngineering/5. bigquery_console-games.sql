/* 1. Calculate what % of Global Sales were made in North America. */
WITH region_total_sales AS(
    SELECT 
        SUM(NA_Sales) AS NA_Sales, 
        SUM(EU_Sales) AS EU_Sales, 
        SUM(JP_Sales) AS JP_Sales, 
        (SUM(NA_Sales) + SUM(EU_Sales) + SUM(JP_Sales)) as total_sales
    FROM `new-project-251007.test.ConsoleGames`
)

SELECT (NA_Sales * 100 / total_sales) AS `North_America_Percentage_Sales`
FROM region_total_sales

/* 2. Extract a view of the console game titles ordered by platform name in ascending order and year of release in descending order. */
SELECT *
FROM `new-project-251007.test.ConsoleGames`
ORDER BY Platform ASC, Year DESC

/* 3. For each game title extract the first four letters of the publisher’s name. */
SELECT Name, SUBSTR(Publisher, 1, 4) AS `Publisher_First_Four_Letter`
FROM `new-project-251007.test.ConsoleGames`

/* 4. Display all console platforms which were released either just before Black Friday or just before Christmas (in any year). */
/* (For Black Friday, the dates vary each year. So, assume the date is 25 which is same as Christmas) */
/* (Only data of platforms released within the month -- Nov and Dec, is extracted) */
SELECT Platform, FirstRetailAvailability
FROM `new-project-251007.test.ConsoleDates`
WHERE (EXTRACT(MONTH FROM FirstRetailAvailability) = 11 AND EXTRACT(DAY FROM FirstRetailAvailability) < 25)
  OR (EXTRACT(MONTH FROM FirstRetailAvailability) = 12 AND EXTRACT(DAY FROM FirstRetailAvailability) < 25)
ORDER BY Platform

/* 5. Order the platforms by their longevity in ascending order (i.e. the platform which was available for the longest at the bottom). */
SELECT Platform, DATE_DIFF(Discontinued, FirstRetailAvailability, day) AS Longevity
FROM `new-project-251007.test.ConsoleDates` 
ORDER BY Longevity

/* 6. Demonstrate how to deal with the Game_year column if the client wants to convert it to a different data type. */
SELECT CAST((CAST(Year AS STRING)) AS DATE)
FROM `new-project-251007.test.ConsoleGames`
/* Reference: https://cloud.google.com/bigquery/docs/manually-changing-schemas#changing_a_columns_data_type */
/* BigQuery data type: https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types#date-type
(BigQuery does not have YEAR data type) */

/* 7. Provide recommendations on how to deal with missing data in the file. */
/* A. Delete rows with missing data. 
   B. Impute missing data with mean/median values. 
   C. Investigate and fill in the missing values. */