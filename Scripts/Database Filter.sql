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

SELECT COUNT(*)
FROM metadata
WHERE Stx = "-";

SELECT COUNT(*)
FROM metadata
WHERE Stx = '-' 
   OR PT = '-' 
   OR Region = '-' 
   OR Country = '-' 
   OR Year = '-';

-- Certifying that missing entries == only "Stx" -- 

DELETE FROM metadata
WHERE Stx = '-' AND id IS NOT NULL;

SELECT * FROM 
metadata;
