-- =============================================================
--  DINOPARK  --  Exercise 6: Stored Procedures
--  Procedures vs Functions:
--  - Procedures can COMMIT/ROLLBACK transactions
--  - Procedures do not return a value (use OUT params or INOUT)
--  - Call with CALL, not SELECT
-- =============================================================


-- -------------------------------------------------------
-- PART A: Simple procedures
-- -------------------------------------------------------

-- A1. Procedure to move a dinosaur to a new enclosure.
CREATE OR REPLACE PROCEDURE move_dinosaur(
    dino_name    TEXT,
    new_enclosure TEXT
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE dinosaurs
    SET    enclosure = new_enclosure
    WHERE  name      = dino_name;

    IF NOT FOUND THEN
        RAISE NOTICE 'Dinosaur % not found.', dino_name;
    ELSE
        RAISE NOTICE '% moved to %.', dino_name, new_enclosure;
    END IF;
END;
$$;

-- Use it:
CALL move_dinosaur('Echo', 'Quarantine Zone');
CALL move_dinosaur('Spike', 'Recovery Wing');

-- Verify:
SELECT name, enclosure, status FROM dinosaurs WHERE name IN ('Echo', 'Spike');


-- A2. Procedure to update a dinosaur's status.
CREATE OR REPLACE PROCEDURE update_status(
    dino_name  TEXT,
    new_status TEXT
)
LANGUAGE plpgsql AS $$
BEGIN
    IF new_status NOT IN ('alive', 'sick', 'escaped', 'deceased') THEN
        RAISE EXCEPTION 'Invalid status: %', new_status;
    END IF;

    UPDATE dinosaurs SET status = new_status WHERE name = dino_name;

    RAISE NOTICE 'Status of % updated to %.', dino_name, new_status;
END;
$$;

CALL update_status('Spike', 'alive');
CALL update_status('Echo',  'alive');

-- Try an invalid status — it should raise an exception:
-- CALL update_status('Rexy', 'napping');


-- -------------------------------------------------------
-- PART B: Procedures with multiple steps
-- -------------------------------------------------------

-- B1. Admit a new dinosaur to the park in one call.
CREATE OR REPLACE PROCEDURE admit_dinosaur(
    p_name        TEXT,
    p_species     TEXT,
    p_birth_year  INT,
    p_enclosure   TEXT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_species_id INT;
BEGIN
    SELECT id INTO v_species_id FROM species WHERE name = p_species;

    IF v_species_id IS NULL THEN
        RAISE EXCEPTION 'Unknown species: %', p_species;
    END IF;

    INSERT INTO dinosaurs (name, species_id, birth_year, enclosure, status)
    VALUES (p_name, v_species_id, p_birth_year, p_enclosure, 'alive');

    RAISE NOTICE 'Welcome to DinoPark, %!', p_name;
END;
$$;

CALL admit_dinosaur('Charlie', 'Velociraptor', 2024, 'Raptor Arena');
CALL admit_dinosaur('Bruno',   'Carnotaurus',  2023, 'North Paddock');

-- Verify:
SELECT d.name, s.name AS species, d.enclosure
FROM   dinosaurs d JOIN species s ON d.species_id = s.id
WHERE  d.name IN ('Charlie', 'Bruno');
-- NOTE: if you ran exercise 01 first, you will see TWO Charlies here.
-- That's because the dinosaurs table has no UNIQUE constraint on name.
-- Question for the class: how would you prevent this?
-- Answer: ALTER TABLE dinosaurs ADD CONSTRAINT uq_dino_name UNIQUE (name);


-- -------------------------------------------------------
-- PART C: Procedures with transactions
-- -------------------------------------------------------

-- C1. Transfer a dinosaur between enclosures — log the move.
--     First create the transfer_log table if not already done.
CREATE TABLE IF NOT EXISTS transfer_log (
    id           SERIAL PRIMARY KEY,
    dinosaur_id  INT  NOT NULL REFERENCES dinosaurs(id),
    from_enclosure TEXT,
    to_enclosure   TEXT,
    transferred_at TIMESTAMP DEFAULT NOW()
);

CREATE OR REPLACE PROCEDURE transfer_dinosaur(
    dino_name     TEXT,
    new_enclosure TEXT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_id           INT;
    v_old_enclosure TEXT;
BEGIN
    SELECT id, enclosure INTO v_id, v_old_enclosure
    FROM   dinosaurs WHERE name = dino_name;

    IF v_id IS NULL THEN
        RAISE EXCEPTION 'Dinosaur % not found', dino_name;
    END IF;

    UPDATE dinosaurs SET enclosure = new_enclosure WHERE id = v_id;

    INSERT INTO transfer_log (dinosaur_id, from_enclosure, to_enclosure)
    VALUES (v_id, v_old_enclosure, new_enclosure);

    RAISE NOTICE 'Transferred % from % to %.',
        dino_name, v_old_enclosure, new_enclosure;
END;
$$;

CALL transfer_dinosaur('Rexy',  'South Paddock');
CALL transfer_dinosaur('Benny', 'Giant Zone');

SELECT * FROM transfer_log;


-- -------------------------------------------------------
-- PART D: Open challenges
-- -------------------------------------------------------

-- D1. Write a procedure release_from_quarantine(dino_name TEXT)
--     that sets status = 'alive' and moves it back to its
--     original enclosure. You'll need to track original enclosure.

-- D2. Write a procedure daily_feeding(enclosure TEXT)
--     that inserts a feeding_log row for every alive dinosaur
--     in that enclosure. (Requires feeding_logs from Exercise 2.)

-- D3. Write a procedure retire_dinosaur(dino_name TEXT)
--     that sets status = 'deceased' and logs a final transfer
--     to 'Fossil Museum'.
