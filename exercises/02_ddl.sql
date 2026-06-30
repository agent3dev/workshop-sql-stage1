-- =============================================================
--  DINOPARK  --  Exercise 2: DDL (Data Definition Language)
--  CREATE, ALTER, DROP
-- =============================================================


-- -------------------------------------------------------
-- PART A: Create a new table
-- -------------------------------------------------------

-- A1. Create a table to log every time a dinosaur is fed.
--     It should record: which dinosaur, what food, and when.
CREATE TABLE feeding_logs (
    id           SERIAL PRIMARY KEY,
    dinosaur_id  INT          NOT NULL REFERENCES dinosaurs(id),
    food         VARCHAR(100) NOT NULL,
    fed_at       TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- Verify it exists:
\d feeding_logs


-- A2. Create a table for park staff (rangers).
--     Columns: id, name, role, hire_date
--     Make name required. role should only allow:
--     'ranger', 'vet', 'handler', 'scientist'
CREATE TABLE rangers (
    id        SERIAL PRIMARY KEY,
    name      VARCHAR(100) NOT NULL,
    role      VARCHAR(20)  NOT NULL CHECK (role IN ('ranger', 'vet', 'handler', 'scientist')),
    hire_date DATE         NOT NULL DEFAULT CURRENT_DATE
);

\d rangers


-- -------------------------------------------------------
-- PART B: Modify an existing table (ALTER)
-- -------------------------------------------------------

-- B1. Add a column 'nickname' to the dinosaurs table.
ALTER TABLE dinosaurs ADD COLUMN nickname VARCHAR(50);

-- Verify:
\d dinosaurs

-- B2. Add a column 'is_venomous' (boolean, default false) to species.
ALTER TABLE species ADD COLUMN is_venomous BOOLEAN NOT NULL DEFAULT FALSE;

-- B3. Rename the column 'nickname' to 'alias'.
ALTER TABLE dinosaurs RENAME COLUMN nickname TO alias;

-- B4. Change the data type of 'alias' to TEXT.
ALTER TABLE dinosaurs ALTER COLUMN alias TYPE TEXT;

-- B5. Drop the 'alias' column — we don't need it.
ALTER TABLE dinosaurs DROP COLUMN alias;


-- -------------------------------------------------------
-- PART C: Drop a table
-- -------------------------------------------------------

-- C1. Create a temporary table, then drop it.
CREATE TABLE temp_test (id SERIAL, note TEXT);
INSERT INTO temp_test (note) VALUES ('this table will not survive');
SELECT * FROM temp_test;
DROP TABLE temp_test;

-- Verify it's gone (this should return an error — that's expected):
-- SELECT * FROM temp_test;


-- -------------------------------------------------------
-- PART D: Constraints
-- -------------------------------------------------------

-- D1. Try inserting a ranger with an invalid role — it should fail.
--     Uncomment to test:
-- INSERT INTO rangers (name, role) VALUES ('John', 'intern');

-- D2. Insert valid rangers.
INSERT INTO rangers (name, role, hire_date) VALUES
    ('Dr. Ellie',  'scientist', '2020-03-15'),
    ('Owen G.',    'handler',   '2019-07-01'),
    ('Dr. Malcolm','scientist', '2018-11-20'),
    ('Ray A.',     'ranger',    '2021-05-10');

SELECT * FROM rangers;


-- -------------------------------------------------------
-- PART E: Open challenges
-- -------------------------------------------------------

-- E1. Add a column 'capacity' (integer) to the dinosaurs table
--     to track how many dinos an enclosure can hold.
--     Hint: ALTER TABLE ... ADD COLUMN

-- E2. Create a table 'incidents' to log escape or injury events.
--     Think about what columns make sense.

-- E3. Add a NOT NULL constraint to an existing nullable column.
--     Hint: ALTER TABLE ... ALTER COLUMN ... SET NOT NULL
--     (you may need to fill nulls first with UPDATE)
