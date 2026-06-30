-- Solutions: DDL open challenges

-- E1. Add capacity column
ALTER TABLE dinosaurs ADD COLUMN capacity INT;

-- E2. Incidents table
CREATE TABLE incidents (
    id           SERIAL PRIMARY KEY,
    dinosaur_id  INT  REFERENCES dinosaurs(id),
    type         VARCHAR(20) CHECK (type IN ('escape', 'injury', 'illness', 'death')),
    description  TEXT,
    occurred_at  TIMESTAMP DEFAULT NOW()
);

-- E3. Set NOT NULL on an existing column (fill nulls first)
UPDATE dinosaurs SET birth_year = 2020 WHERE birth_year IS NULL;
ALTER TABLE dinosaurs ALTER COLUMN birth_year SET NOT NULL;
