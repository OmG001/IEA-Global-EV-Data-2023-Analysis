use ev;
SELECT 
    *
FROM
    evdata23;
-- 1. Retrieve all data for the region "Australia".

SELECT 
    *
FROM
    evdata23
WHERE
    Region = 'Australia';

-- 2. List distinct powertrain types available in the dataset.

SELECT DISTINCT
    (Powertrain)
FROM
    evdata23;

-- 3. Retrieve all entries with the parameter "EV sales".

SELECT 
    *
FROM
    evdata23
WHERE
    Parameter = 'EV sales';

-- 4. Filter data for the year 2020 and mode "Cars".

SELECT 
    *
FROM
    evdata23
WHERE
    Year = '2020' AND Mode = 'Cars';

-- 5. Count the number of records in the dataset.

SELECT 
    COUNT(*)
FROM
    evdata23;

-- 6. Retrieve data for "BEV" powertrains with units in "Vehicles"

SELECT 
    *
FROM
    evdata23
WHERE
    Powertrain = 'BEV' AND Unit = 'Vehicles';

-- 1. Find the total EV stock for all regions in 2020.

SELECT 
    COUNT(*)
FROM
    evdata23
WHERE
    Parameter = 'EV stock' AND year = '2020';

-- 2. Calculate the average EV sales share for the "Cars" mode.

SELECT 
    AVG(Value)
FROM
    evdata23
WHERE
    Parameter = 'EV sales' AND Mode = 'Cars';

-- 3. Find the maximum EV stock value for "BEV" powertrains.

SELECT 
    MAX(Value)
FROM
    evdata23
WHERE
    Powertrain = 'BEV'
        AND Parameter = 'EV stock';

-- 4. Get the total EV sales for each region.

SELECT 
    SUM(Value), Region
FROM
    evdata23
WHERE
    Parameter = 'EV sales'
GROUP BY Region;

-- 5. Count how many records exist for each powertrain type.

SELECT 
    COUNT(*) AS RecordCount, Powertrain
FROM
    evdata23
GROUP BY Powertrain;

-- 6. Calculate the minimum EV sales share for "Historical" category data.

SELECT 
    MIN(Value) AS MinSales
FROM
    evdata23
WHERE
    Category = 'Historical'
        AND Parameter = 'EV sale';

-- 1. Using a Common Table Expression (CTE) to calculate total EV stock by region for 2020.

WITH TotalStock AS (
 SELECT Region, SUM(Value) AS TotalEVStock 
 FROM evdata23 
 WHERE Parameter = 'EV stock' AND Year = 2020 
 GROUP BY Region
)
SELECT * 
FROM TotalStock;


-- 2. Find the top 3 regions with the highest EV sales using a window function.

SELECT Region, SUM(Value) AS TotalEVSales,
 RANK() OVER (ORDER BY sum(Value) DESC) AS SalesRank
FROM evdata23 
WHERE Parameter = 'EV sales' 
GROUP BY Region
LIMIT 3;

-- 3. Calculate the cumulative EV stock for each year using a window function.

SELECT 
    Year, SUM(Value) AS CumulativeEVStock
FROM
    evdata23
WHERE
    Parameter = 'EV stock'
GROUP BY Year
ORDER BY Year;

-- 4. Retrieve the average EV sales share for each mode across all years using a CTE.

with AverageSales as (
select avg(Value) as AverageSalesStock, Mode from evdata23 where Parameter = 'EV Sales' group by Mode
)
select * from AverageSales;
    
-- 5. Rank EV sales share within each region by year using a window function.

SELECT Region, Year, Value AS EVSalesShare,
 RANK() OVER (PARTITION BY Region ORDER BY Value DESC) 
AS YearlyRank
FROM evdata23 
WHERE Parameter = 'EV sales';

-- • Join to retrieve the total EV stock for each region and its continent.

SELECT 
    sum(evdata23.Value) AS TotalStock, Regions.Continent, evdata23.Region
FROM
    evdata23
        INNER JOIN
    Regions ON evdata23.Region = Regions.Region
WHERE
   evdata23.Parameter = 'EV stock'
GROUP BY evdata23.Region, Regions.Continent
order by TotalStock desc;

SELECT ed.Region, ri.Continent, SUM(ed.Value) AS TotalStock 
FROM evdata23 ed 
INNER JOIN Regions ri 
ON ed.Region = ri.Region 
WHERE ed.Parameter = 'EV stock'
GROUP BY ed.Region, ri.Continent 
ORDER BY TotalStock DESC;


-- • Get the average EV sales share for regions in Asia and include GDP data from region_info.

SELECT ed.Region,ri.Continent, ri.`GDP (in trillion)`, AVG(ed.Value) AS AvgEVSalesShare 
FROM evdata23 ed 
INNER JOIN Regions ri 
ON ed.Region = ri.Region 
WHERE ri.Continent = 'Asia' AND ed.Parameter = 'EV sales share'
GROUP BY ed.Region, ri.`GDP (in trillion)` 
ORDER BY AvgEVSalesShare DESC;