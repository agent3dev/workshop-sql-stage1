-- Solutions: Functions open challenges

-- D1. is_safe_to_visit
CREATE OR REPLACE FUNCTION is_safe_to_visit(enc TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN NOT EXISTS (
        SELECT 1 FROM dinosaurs
        WHERE  enclosure = enc AND status IN ('escaped', 'sick')
    );
END;
$$ LANGUAGE plpgsql;

SELECT enclosure, is_safe_to_visit(enclosure)
FROM   (SELECT DISTINCT enclosure FROM dinosaurs) e;

-- D2. heaviest_in_era
CREATE OR REPLACE FUNCTION heaviest_in_era(era_name TEXT)
RETURNS TEXT AS $$
DECLARE
    result TEXT;
BEGIN
    SELECT s.name INTO result
    FROM   species s
    JOIN   eras    e ON s.era_id = e.id
    WHERE  e.name = era_name
    ORDER  BY s.avg_weight_kg DESC
    LIMIT  1;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

SELECT heaviest_in_era('Jurassic');
SELECT heaviest_in_era('Cretaceous');
SELECT heaviest_in_era('Triassic');
