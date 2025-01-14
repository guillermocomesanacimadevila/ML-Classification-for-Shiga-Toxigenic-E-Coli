-- SELECT COUNT(*)
-- FROM metadata_f;

SELECT Region, COUNT(*) as Region_Count
FROM metadata_f
GROUP BY Region
ORDER BY Region_Count DESC;

SELECT Country, COUNT(*) as Country_Count
FROM metadata_f
GROUP BY Country
ORDER BY Country_Count DESC;

SELECT Stx, COUNT(*) as Stx_Count
FROM metadata_f
GROUP BY Stx
ORDER BY Stx_Count DESC;

SELECT PT, COUNT(*) AS PT_Count
FROM metadata_f
GROUP BY PT
ORDER BY PT_Count Desc;

SELECT Country, COUNT(*) as Country_count -- Portugal!!!
FROM metadata_f
GROUP BY Country
ORDER BY Country_count ASC;

SELECT Country, COUNT(*) AS country_counter 
FROM metadata_f
WHERE Country LIKE 'Por%'
GROUP BY Country;

-- Check if same error = ["Region"]
/**
SELECT Region, COUNT(*) as Reg_counter
FROM metadata_f; **/

SELECT COUNT(*) 
FROM metadata_f
WHERE Stx <> '-' 
  AND PT NOT IN ('untypable', '#N/A', 'NA')
  AND Stx <> 'NA'
  AND Country <> "Portgual"
ORDER BY Region;