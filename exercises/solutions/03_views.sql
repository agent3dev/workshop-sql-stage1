-- Solutions: Views open challenges

-- E1. Heavyweights view
CREATE VIEW heavyweights AS
SELECT name, avg_weight_kg, diet, avg_length_m
FROM   species
WHERE  avg_weight_kg > 5000
ORDER  BY avg_weight_kg DESC;

-- E2. Jurassic Park view
CREATE VIEW jurassic_park AS
SELECT d.name AS dinosaur, s.name AS species, d.enclosure
FROM   dinosaurs d
JOIN   species   s ON d.species_id = s.id
JOIN   eras      e ON s.era_id     = e.id
WHERE  e.name = 'Jurassic' AND d.status = 'alive';

-- E3. Highest escape rate enclosure
SELECT enclosure,
       escaped::FLOAT / NULLIF(total, 0) AS escape_rate
FROM   enclosure_summary
ORDER  BY escape_rate DESC NULLS LAST
LIMIT  1;
