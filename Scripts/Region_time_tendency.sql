-- Select all UK samples for temporal trend

SELECT * 
FROM metadata_f
WHERE Region = 'UK'
  AND Stx <> '-' 
  AND PT NOT IN ('untypable', '#N/A', 'NA')
  AND Stx <> 'NA'
ORDER BY Year;

SELECT Region, Year
FROM metadata_f
WHERE Stx <> '-' 
  AND PT <> 'untypable' 
  AND PT <> '#N/A'
  AND PT <> 'NA'
  AND Stx <> 'NA'
ORDER BY Region, Year;

SELECT DISTINCT Region
FROM metadata_f;