-- =============================================================
--  DINOPARK  --  Exercise 5: Functions (PL/pgSQL)
-- =============================================================


-- -------------------------------------------------------
-- PART A: Simple functions
-- -------------------------------------------------------

-- A1. A function that returns the era name for a given species.
CREATE OR REPLACE FUNCTION get_era(species_name TEXT)
RETURNS TEXT AS $$
DECLARE
    era_name TEXT;
BEGIN
    SELECT e.name INTO era_name
    FROM   species s
    JOIN   eras e ON s.era_id = e.id
    WHERE  s.name = species_name;

    IF era_name IS NULL THEN
        RETURN 'Species not found';
    END IF;

    RETURN era_name;
END;
$$ LANGUAGE plpgsql;

-- Use it:
SELECT get_era('Tyrannosaurus Rex');
SELECT get_era('Velociraptor');
SELECT get_era('Diplodocus');
SELECT get_era('NotADino');


-- A2. A function that counts how many dinosaurs are in an enclosure.
CREATE OR REPLACE FUNCTION count_in_enclosure(enc TEXT)
RETURNS INT AS $$
DECLARE
    total INT;
BEGIN
    SELECT COUNT(*) INTO total
    FROM   dinosaurs
    WHERE  enclosure = enc AND status = 'alive';

    RETURN total;
END;
$$ LANGUAGE plpgsql;

SELECT count_in_enclosure('Raptor Arena');
SELECT count_in_enclosure('Savanna Zone');
SELECT count_in_enclosure('North Paddock');


-- -------------------------------------------------------
-- PART B: Functions with logic
-- -------------------------------------------------------

-- B1. Return a danger level based on diet and size.
CREATE OR REPLACE FUNCTION danger_level(species_name TEXT)
RETURNS TEXT AS $$
DECLARE
    s_diet    TEXT;
    s_length  NUMERIC;
BEGIN
    SELECT diet, avg_length_m INTO s_diet, s_length
    FROM   species
    WHERE  name = species_name;

    IF s_diet = 'carnivore' AND s_length >= 10 THEN
        RETURN 'EXTREME';
    ELSIF s_diet = 'carnivore' THEN
        RETURN 'HIGH';
    ELSIF s_diet = 'herbivore' AND s_length >= 15 THEN
        RETURN 'MEDIUM';  -- can still trample you
    ELSE
        RETURN 'LOW';
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT name, danger_level(name) FROM species ORDER BY name;


-- B2. A function that returns a full summary sentence for a dinosaur.
CREATE OR REPLACE FUNCTION dino_bio(dino_name TEXT)
RETURNS TEXT AS $$
DECLARE
    d   dinosaurs%ROWTYPE;
    s   species%ROWTYPE;
    e   eras%ROWTYPE;
BEGIN
    SELECT * INTO d FROM dinosaurs WHERE name = dino_name LIMIT 1;
    SELECT * INTO s FROM species   WHERE id   = d.species_id;
    SELECT * INTO e FROM eras      WHERE id   = s.era_id;

    RETURN d.name || ' is a ' || s.diet || ' ' || s.name
        || ' from the ' || e.name || ' era. '
        || 'It lives in ' || d.enclosure
        || ' and is currently ' || d.status || '.';
END;
$$ LANGUAGE plpgsql;

SELECT dino_bio('Rexy');
SELECT dino_bio('Blue');
SELECT dino_bio('Longneck');


-- -------------------------------------------------------
-- PART C: Functions that return tables
-- -------------------------------------------------------

-- C1. Return all dinosaurs in a given enclosure.
CREATE OR REPLACE FUNCTION enclosure_roster(enc TEXT)
RETURNS TABLE(dinosaur TEXT, species TEXT, status TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT d.name::TEXT, s.name::TEXT, d.status::TEXT
    FROM   dinosaurs d
    JOIN   species   s ON d.species_id = s.id
    WHERE  d.enclosure = enc;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM enclosure_roster('Savanna Zone');
SELECT * FROM enclosure_roster('Raptor Arena');


-- -------------------------------------------------------
-- PART D: Open challenges
-- -------------------------------------------------------

-- D1. Write a function is_safe_to_visit(enclosure TEXT)
--     that returns FALSE if any escaped or sick dino is there.

-- D2. Write a function heaviest_in_era(era_name TEXT)
--     that returns the name of the heaviest species in that era.

-- D3. Modify danger_level() to also consider is_venomous
--     (from Exercise 2). Venomous carnivores = 'EXTREME' always.
