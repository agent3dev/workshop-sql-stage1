-- =============================================================
--  DINOPARK  --  Exercise 1: First Queries
--  Complete each block. Run it. See what happens.
-- =============================================================


-- -------------------------------------------------------
-- PART A: Looking around  (SELECT)
-- -------------------------------------------------------

-- A1. List all eras.
SELECT * FROM eras;

-- A2. List all species names and their diet.
SELECT name, diet FROM species;

-- A3. List only the carnivore species.
-- Hint: WHERE diet = '...'
SELECT name, diet FROM species
WHERE diet = 'carnivore';

-- A4. List all dinosaurs that are currently alive.
SELECT name, enclosure FROM dinosaurs
WHERE status = 'alive';

-- A5. How many dinosaurs live in 'Raptor Arena'?
-- Hint: COUNT(*)
SELECT COUNT(*) FROM dinosaurs
WHERE enclosure = 'Raptor Arena';

-- A6. Which dinosaur escaped?  Show its name and enclosure.
SELECT name, enclosure FROM dinosaurs
WHERE status = 'escaped';


-- -------------------------------------------------------
-- PART B: Sorting & Limiting  (ORDER BY, LIMIT)
-- -------------------------------------------------------

-- B1. List the 3 heaviest species (avg_weight_kg).
SELECT name, avg_weight_kg FROM species
ORDER BY avg_weight_kg DESC
LIMIT 3;

-- B2. List species ordered from longest to shortest (avg_length_m).
SELECT name, avg_length_m FROM species
ORDER BY avg_length_m DESC;

-- B3. Which species was discovered first?
SELECT name, discovered_year FROM species
ORDER BY discovered_year ASC
LIMIT 1;


-- -------------------------------------------------------
-- PART C: Joining tables  (JOIN)
-- -------------------------------------------------------

-- C1. List each dinosaur with its species name.
-- Hint: JOIN species ON dinosaurs.species_id = species.id
SELECT dinosaurs.name   AS dinosaur,
       species.name     AS species
FROM   dinosaurs
JOIN   species ON dinosaurs.species_id = species.id;

-- C2. List each dinosaur with its species name AND era name.
SELECT dinosaurs.name   AS dinosaur,
       species.name     AS species,
       eras.name        AS era
FROM   dinosaurs
JOIN   species ON dinosaurs.species_id = species.id
JOIN   eras    ON species.era_id       = eras.id;

-- C3. List all dinosaurs in the Cretaceous era.
SELECT dinosaurs.name AS dinosaur, species.name AS species
FROM   dinosaurs
JOIN   species ON dinosaurs.species_id = species.id
JOIN   eras    ON species.era_id       = eras.id
WHERE  eras.name = 'Cretaceous';


-- -------------------------------------------------------
-- PART D: Adding data  (INSERT)
-- -------------------------------------------------------

-- D1. A new Velociraptor arrived! Add it.
--     Name: 'Charlie', born 2023, enclosure: 'Raptor Arena', status: 'alive'
--     Hint: Velociraptor is species_id = 3
INSERT INTO dinosaurs (name, species_id, birth_year, enclosure, status)
VALUES ('Charlie', 3, 2023, 'Raptor Arena', 'alive');

-- Verify:
SELECT * FROM dinosaurs WHERE name = 'Charlie';


-- -------------------------------------------------------
-- PART E: Updating data  (UPDATE)
-- -------------------------------------------------------

-- E1. Spike the Stegosaurus got better. Change its status to 'alive'.
UPDATE dinosaurs
SET    status = 'alive'
WHERE  name   = 'Spike';

-- Verify:
SELECT name, status FROM dinosaurs WHERE name = 'Spike';

-- E2. Echo the Velociraptor was recaptured. Change status to 'alive'.
UPDATE dinosaurs
SET    status = 'alive'
WHERE  name   = 'Echo';

-- Verify:
SELECT name, status FROM dinosaurs WHERE name = 'Echo';


-- -------------------------------------------------------
-- PART F: Your turn!  (open challenges)
-- -------------------------------------------------------

-- F1. How many species are herbivores?

-- F2. List every dinosaur born after 2019.

-- F3. Which enclosure has the most dinosaurs?
--     Hint: GROUP BY enclosure, COUNT(*), ORDER BY

-- F4. Add your own dinosaur. Give it any name you like.
--     Pick a real species from the list.
