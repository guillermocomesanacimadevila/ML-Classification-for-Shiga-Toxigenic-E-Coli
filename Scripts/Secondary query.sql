SELECT COUNT(*) FROM metadata_f;

SELECT COUNT(*) FROM metadata_f
WHERE Stx = '-';

SELECT COUNT(*) FROM metadata_f
WHERE PT = 'untypable';

SELECT COUNT(*) FROM metadata_f
WHERE PT = '#N/A';

SELECT *
FROM metadata_f
WHERE Stx <> '-' 
  AND PT <> 'untypable' 
  AND PT <> '#N/A'
  AND PT <> 'NA'
  AND Stx <> 'NA';
  
-- Create new counters table -- filtered_metadata

SELECT Region, COUNT(*) AS Region_Count
FROM filtered_metadata
GROUP BY Region
ORDER BY Region;

CREATE TABLE metadata_counters (
Region TEXT,
Counter INTEGER
);

INSERT INTO metadata_counters (Region, Counter)
VALUES 
	("UK", 2059),
    ("Australasia", 6),
    ("C. America", 26),
    ("C.Europe", 55),
    ("M.East", 154),
    ("N. Africa", 84),
    ("N. America", 11),
    ("N. Europe", 18),
    ("S. America", 3),
    ("S. Europe", 231),
    ("Subsaharan Africa", 26),
    ("Asia", 54);
    
SELECT * FROM metadata_counters;