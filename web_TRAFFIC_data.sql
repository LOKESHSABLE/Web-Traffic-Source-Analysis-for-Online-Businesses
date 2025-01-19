SELECT * FROM web_traffic.web_traffic_data;

---------------------/*converting date format*/-------------------------------

SELECT DATE(`Date`)
from web_traffic_data;

ALTER TABLE web_traffic_data
MODIFY COLUMN Date DATE;

UPDATE web_traffic_data
SET Date = DATE(`Date`);

SELECT * FROM web_traffic.web_traffic_data;

---------------------/*checking for the duplicates*/---------------------------

SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY `Date`, `Channel`, `Campaign_Name`, `Device_Type`, `Geography`,
                               `Traffic_Source`, `User_Type`, `Sessions`, `Unique_Visitors`, `Page_Views`, 
                               `Bounce_Rate`, `Average_Session_Duration`, `Conversion_Rate`, `Conversions`, 
                               `Cost`, `Revenue`, `ROI`, `Exit_Rate` ORDER BY `Date`) AS row_num
    FROM web_traffic_data
) AS subquery
WHERE row_num > 1;

---------------------------/*channels overview*/---------------------------------

SELECT * FROM web_traffic.web_traffic_data;

SELECT DISTINCT `Channel`
FROM web_traffic_data;

SELECT DISTINCT `Channel`, SUM(Unique_Visitors) Total_Users
FROM web_traffic_data
GROUP BY `Channel`
ORDER BY Total_Users DESC;

SELECT DISTINCT `Channel`,Device_Type, SUM(Unique_Visitors) Total_Users_Devices
FROM web_traffic_data
GROUP BY `Channel`,Device_Type
ORDER BY `Channel`,Total_Users_Devices;

SELECT DISTINCT `Channel`,Geography, SUM(Unique_Visitors) Total_Users_Geography
FROM web_traffic_data
GROUP BY `Channel`,Geography
ORDER BY `Channel`,Total_Users_Geography;

SELECT DISTINCT `Channel`,User_Type, COUNT(User_Type) Total_Users_Type
FROM web_traffic_data
GROUP BY `Channel`,User_Type
ORDER BY `Channel`,Total_Users_Type;

SELECT DISTINCT `Channel`,ROUND(AVG(Bounce_Rate),2) Average_Bounce_Rate
FROM web_traffic_data
GROUP BY `Channel`
ORDER BY Average_Bounce_Rate DESC;

SELECT DISTINCT `Channel`,ROUND(AVG(Conversion_Rate),2) Average_Conversion_Rate
FROM web_traffic_data
GROUP BY `Channel`
ORDER BY Average_Conversion_Rate DESC;

SELECT DISTINCT `Channel`,ROUND(SUM(Revenue),2) Total_Revenue
FROM web_traffic_data
GROUP BY `Channel`
ORDER BY Total_Revenue DESC;

SELECT DISTINCT `Channel`,ROUND(AVG(ROI),2) Average_ROI
FROM web_traffic_data
GROUP BY `Channel`
ORDER BY Average_ROI DESC;

SELECT DISTINCT `Channel`,Traffic_Source, COUNT(Traffic_Source) Total_Traffic_Source
FROM web_traffic_data
GROUP BY `Channel`,Traffic_Source
ORDER BY `Channel`,Total_Traffic_Source DESC;

SELECT *
FROM (
SELECT `Channel`,Traffic_Source, COUNT(Traffic_Source) AS Total_Traffic_Source,
ROW_NUMBER() OVER(PARTITION BY `Channel` ORDER BY COUNT(Traffic_Source) DESC) ROW_NUM
FROM web_traffic_data
GROUP BY `Channel`,Traffic_Source
) AS SUBQUERY
WHERE ROW_NUM <= 3;

---------------------------/*Campaign  Overview*/---------------------------------

SELECT * FROM web_traffic.web_traffic_data;

SELECT *
FROM(
SELECT Campaign_Name,`Channel`,SUM(Unique_Visitors) Total_Users,
ROW_NUMBER() OVER(PARTITION BY Campaign_Name ORDER BY SUM(Unique_Visitors)DESC) AS ROW_NUM
FROM web_traffic_data
GROUP BY Campaign_Name,`Channel`
) AS SUBQUERY
WHERE ROW_NUM <= 3;

SELECT *
FROM(
SELECT Campaign_Name,Geography,SUM(Unique_Visitors) Total_Users,
ROW_NUMBER() OVER(PARTITION BY Campaign_Name ORDER BY SUM(Unique_Visitors)DESC) AS ROW_NUM
FROM web_traffic_data
GROUP BY Campaign_Name,Geography
) AS SUBQUERY
WHERE ROW_NUM <= 3;

SELECT *
FROM(
SELECT Campaign_Name,Traffic_Source,SUM(Unique_Visitors) Total_Users,
ROW_NUMBER() OVER(PARTITION BY Campaign_Name ORDER BY SUM(Unique_Visitors)DESC) AS ROW_NUM
FROM web_traffic_data
GROUP BY Campaign_Name,Traffic_Source
) AS SUBQUERY
WHERE ROW_NUM <= 3;

SELECT Campaign_Name, ROUND(AVG(Conversion_Rate),4) Average_Conversion_Rate
FROM web_traffic_data
GROUP BY Campaign_Name
ORDER BY Average_Conversion_Rate DESC;

SELECT Campaign_Name, ROUND(SUM(Revenue),2) AS Total_Revenue
FROM web_traffic_data
GROUP BY Campaign_Name
ORDER BY Total_Revenue DESC;

SELECT Campaign_Name, ROUND(AVG(ROI),2) Average_ROI
FROM web_traffic_data
GROUP BY Campaign_Name
ORDER BY Average_ROI DESC;


----------------------/*COST PER ACQUISITION*/------------------------
SELECT 
    `Channel`, 
    `Campaign_Name`, 
    CASE 
        WHEN SUM(`Conversions`) > 0 THEN SUM(`Cost`) / SUM(`Conversions`)
        ELSE NULL
    END AS Cost_Per_Acquisition
FROM web_traffic_data
GROUP BY `Channel`, `Campaign_Name`
ORDER BY `Channel`, `Campaign_Name`;




