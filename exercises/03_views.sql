-- =============================================================
--  DINOPARK  --  Exercise 3: Views
-- =============================================================


-- -------------------------------------------------------
-- PART A: Create simple views
-- -------------------------------------------------------

-- A1. Create a view that shows only carnivore species.
CREATE VIEW carnivores AS
SELECT id, name, avg_length_m, avg_weight_kg, discovered_year
FROM   species
WHERE  diet = 'carnivore';

-- Use it like a table:
SELECT * FROM carnivores;

-- A2. Create a view of all escaped or sick dinosaurs.
CREATE VIEW needs_attention AS
SELECT d.name AS dinosaur, s.name AS species, d.status, d.enclosure
FROM   dinosaurs d
JOIN   species s ON d.species_id = s.id
WHERE  d.status IN ('escaped', 'sick');

SELECT * FROM needs_attention;

-- A3. Create a view that shows each dinosaur with full details.
CREATE VIEW park_roster AS
SELECT
    d.id,
    d.name          AS dinosaur,
    s.name          AS species,
    s.diet,
    e.name          AS era,
    d.enclosure,
    d.status,
    d.birth_year
FROM  dinosaurs d
JOIN  species s ON d.species_id = s.id
JOIN  eras    e ON s.era_id     = e.id;

SELECT * FROM park_roster ORDER BY era, species;


-- -------------------------------------------------------
-- PART B: Aggregate views
-- -------------------------------------------------------

-- B1. Create a view that summarises dinosaur counts per enclosure.
CREATE VIEW enclosure_summary AS
SELECT
    enclosure,
    COUNT(*)                                        AS total,
    COUNT(*) FILTER (WHERE status = 'alive')        AS alive,
    COUNT(*) FILTER (WHERE status = 'escaped')      AS escaped,
    COUNT(*) FILTER (WHERE status = 'sick')         AS sick
FROM  dinosaurs
GROUP BY enclosure;

SELECT * FROM enclosure_summary ORDER BY total DESC;

-- B2. Create a view showing species count per era and diet.
CREATE VIEW species_by_era_diet AS
SELECT
    e.name  AS era,
    s.diet,
    COUNT(*) AS species_count
FROM  species s
JOIN  eras e ON s.era_id = e.id
GROUP BY e.name, s.diet
ORDER BY e.name, s.diet;

SELECT * FROM species_by_era_diet;


-- -------------------------------------------------------
-- PART C: Updating through a view
-- -------------------------------------------------------

-- C1. park_roster is read-only (it joins 3 tables), but
--     a simple single-table view CAN be updated.
--     Create an updatable view for alive dinosaurs only.
CREATE VIEW alive_dinosaurs AS
SELECT id, name, species_id, enclosure, birth_year, status
FROM   dinosaurs
WHERE  status = 'alive';

-- Update through the view — move Blue to a new enclosure:
UPDATE alive_dinosaurs
SET    enclosure = 'New Raptor Arena'
WHERE  name = 'Blue';

-- Verify on the base table:
SELECT name, enclosure FROM dinosaurs WHERE name = 'Blue';


-- -------------------------------------------------------
-- PART D: Drop a view
-- -------------------------------------------------------
DROP VIEW carnivores;
-- Re-create it (or leave it dropped — your call).


-- -------------------------------------------------------
-- PART E: Open challenges
-- -------------------------------------------------------

-- E1. Create a view 'heavyweights' that shows species
--     heavier than 5000 kg, ordered by weight descending.

-- E2. Create a view 'jurassic_park' that shows only
--     Jurassic-era dinosaurs currently alive.

-- E3. Using the enclosure_summary view, find which
--     enclosure has the highest escape rate.
