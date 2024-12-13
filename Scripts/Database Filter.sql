-- SELECT * FROM 
-- metadata;

SELECT COUNT(*)
FROM metadata
WHERE Region = "UK";

SELECT DISTINCT Region
FROM metadata; 

SELECT Region, COUNT(*) AS Region_Count
FROM metadata
GROUP BY Region
ORDER BY Region;

-- Aim to filter by Stx variant -- 

SELECT Region, COUNT(*) AS Region_Count
FROM metadata
WHERE Stx = "stx2a"
GROUP BY Region
ORDER BY Region;