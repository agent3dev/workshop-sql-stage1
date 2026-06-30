-- =============================================================
--  DINOPARK  --  Exercise 7: Triggers
--  Triggers fire automatically on INSERT / UPDATE / DELETE
--  BEFORE triggers can modify the row before it's saved
--  AFTER triggers run after the change is committed
-- =============================================================


-- -------------------------------------------------------
-- PART A: BEFORE INSERT trigger
-- -------------------------------------------------------

-- A1. Auto-capitalize dinosaur names on insert.
CREATE OR REPLACE FUNCTION capitalize_dino_name()
RETURNS TRIGGER AS $$
BEGIN
    NEW.name := INITCAP(NEW.name);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_capitalize_name
BEFORE INSERT ON dinosaurs
FOR EACH ROW EXECUTE FUNCTION capitalize_dino_name();

-- Test it — insert with lowercase name:
INSERT INTO dinosaurs (name, species_id, birth_year, enclosure, status)
SELECT 'fluffy', id, 2024, 'Raptor Arena', 'alive'
FROM   species WHERE name = 'Velociraptor';

-- Should be stored as 'Fluffy':
SELECT name FROM dinosaurs WHERE name = 'Fluffy';


-- -------------------------------------------------------
-- PART B: AFTER UPDATE trigger — audit log
-- -------------------------------------------------------

-- B1. Create an audit table to record every status change.
CREATE TABLE IF NOT EXISTS status_audit (
    id          SERIAL PRIMARY KEY,
    dinosaur_id INT  NOT NULL,
    dino_name   TEXT NOT NULL,
    old_status  TEXT,
    new_status  TEXT,
    changed_at  TIMESTAMP DEFAULT NOW()
);

-- B2. Trigger function that logs status changes.
CREATE OR REPLACE FUNCTION log_status_change()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status IS DISTINCT FROM NEW.status THEN
        INSERT INTO status_audit (dinosaur_id, dino_name, old_status, new_status)
        VALUES (OLD.id, OLD.name, OLD.status, NEW.status);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_status_audit
AFTER UPDATE OF status ON dinosaurs
FOR EACH ROW EXECUTE FUNCTION log_status_change();

-- Test it:
UPDATE dinosaurs SET status = 'sick'    WHERE name = 'Rexy';
UPDATE dinosaurs SET status = 'alive'   WHERE name = 'Rexy';
UPDATE dinosaurs SET status = 'escaped' WHERE name = 'Delta';

SELECT * FROM status_audit ORDER BY changed_at;


-- -------------------------------------------------------
-- PART C: BEFORE INSERT trigger — enforce business rules
-- -------------------------------------------------------

-- C1. Prevent adding carnivores to herbivore-only enclosures.
--     Define herbivore-only enclosures:
CREATE TABLE IF NOT EXISTS safe_enclosures (
    enclosure TEXT PRIMARY KEY
);
INSERT INTO safe_enclosures VALUES ('Valley Pen'), ('Savanna Zone');

CREATE OR REPLACE FUNCTION check_enclosure_safety()
RETURNS TRIGGER AS $$
DECLARE
    v_diet TEXT;
BEGIN
    SELECT diet INTO v_diet FROM species WHERE id = NEW.species_id;

    IF v_diet = 'carnivore' AND EXISTS (
        SELECT 1 FROM safe_enclosures WHERE enclosure = NEW.enclosure
    ) THEN
        RAISE EXCEPTION
            'Cannot place carnivore in safe enclosure: %', NEW.enclosure;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_enclosure_safety
BEFORE INSERT ON dinosaurs
FOR EACH ROW EXECUTE FUNCTION check_enclosure_safety();

-- Test — this should fail:
-- INSERT INTO dinosaurs (name, species_id, birth_year, enclosure, status)
-- SELECT 'Sneaky', id, 2024, 'Valley Pen', 'alive'
-- FROM   species WHERE name = 'Velociraptor';

-- This should succeed:
INSERT INTO dinosaurs (name, species_id, birth_year, enclosure, status)
SELECT 'Daisy', id, 2024, 'Valley Pen', 'alive'
FROM   species WHERE name = 'Triceratops';


-- -------------------------------------------------------
-- PART D: List and drop triggers
-- -------------------------------------------------------

-- List all triggers on the dinosaurs table:
SELECT trigger_name, event_manipulation, action_timing
FROM   information_schema.triggers
WHERE  event_object_table = 'dinosaurs';

-- Drop a trigger:
DROP TRIGGER trg_capitalize_name ON dinosaurs;


-- -------------------------------------------------------
-- PART E: Open challenges
-- -------------------------------------------------------

-- E1. Create a trigger that sets birth_year to the current year
--     automatically if it is not provided on INSERT.

-- E2. Create a trigger that prevents updating a deceased dinosaur
--     (status = 'deceased' should be final).

-- E3. Create a trigger that fires on DELETE and logs the
--     deleted dinosaur's name and species to a 'deletions_log' table.
