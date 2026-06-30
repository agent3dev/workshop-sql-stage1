-- =============================================================
--  DINOPARK  --  Exercise 4: Indexes
-- =============================================================


-- -------------------------------------------------------
-- PART A: EXPLAIN — see what the DB is doing
-- -------------------------------------------------------

-- A1. Run a query and look at its execution plan.
--     COST = estimated work. Seq Scan = reading every row.
EXPLAIN SELECT * FROM dinosaurs WHERE status = 'escaped';

-- A2. EXPLAIN ANALYZE actually runs the query and shows real times.
EXPLAIN ANALYZE SELECT * FROM dinosaurs WHERE status = 'escaped';


-- -------------------------------------------------------
-- PART B: Create indexes
-- -------------------------------------------------------

-- B1. Add an index on dinosaurs.status (we filter by this often).
CREATE INDEX idx_dinosaurs_status ON dinosaurs(status);

-- Run EXPLAIN again — notice the plan may change:
EXPLAIN SELECT * FROM dinosaurs WHERE status = 'escaped';

-- B2. Add an index on species.diet.
CREATE INDEX idx_species_diet ON species(diet);

EXPLAIN SELECT * FROM species WHERE diet = 'carnivore';

-- B3. Add an index on dinosaurs.enclosure.
CREATE INDEX idx_dinosaurs_enclosure ON dinosaurs(enclosure);

-- B4. Add a composite index — useful when filtering by two columns.
CREATE INDEX idx_dinosaurs_status_enclosure ON dinosaurs(status, enclosure);

EXPLAIN SELECT * FROM dinosaurs WHERE status = 'alive' AND enclosure = 'Raptor Arena';


-- -------------------------------------------------------
-- PART C: List and drop indexes
-- -------------------------------------------------------

-- C1. List all indexes on the dinosaurs table.
SELECT indexname, indexdef
FROM   pg_indexes
WHERE  tablename = 'dinosaurs';

-- C2. Drop an index we no longer need.
DROP INDEX idx_dinosaurs_status_enclosure;


-- -------------------------------------------------------
-- PART D: Unique indexes
-- -------------------------------------------------------

-- D1. Ensure no two species have the same name.
--     (The UNIQUE constraint on species.name already does this,
--      but you can also create it as a standalone index.)
CREATE UNIQUE INDEX idx_species_name_unique ON species(name);

-- D2. Try inserting a duplicate — it should fail:
-- INSERT INTO species (name, era_id, diet) VALUES ('Velociraptor', 3, 'carnivore');


-- -------------------------------------------------------
-- PART E: Open challenges
-- -------------------------------------------------------

-- E1. Which queries in 01_first_queries.sql would benefit
--     most from an index? Create those indexes.

-- E2. Add an index that would speed up:
--     SELECT * FROM species ORDER BY discovered_year;

-- E3. Use EXPLAIN ANALYZE to compare a query with and
--     without an index. Record the cost difference.
