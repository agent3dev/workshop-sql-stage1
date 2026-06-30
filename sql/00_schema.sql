-- =============================================================
--  DINOPARK DATABASE  --  Schema
--  Workshop SQL Stage 1
-- =============================================================

-- Eras (Triassic, Jurassic, Cretaceous)
CREATE TABLE IF NOT EXISTS eras (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(50)  NOT NULL UNIQUE,
    started_mya INT          NOT NULL,  -- million years ago
    ended_mya   INT          NOT NULL
);

-- Dinosaur species
CREATE TABLE IF NOT EXISTS species (
    id           SERIAL PRIMARY KEY,
    name         VARCHAR(100) NOT NULL UNIQUE,
    era_id       INT          NOT NULL REFERENCES eras(id),
    diet         VARCHAR(20)  NOT NULL CHECK (diet IN ('carnivore', 'herbivore', 'omnivore')),
    avg_length_m NUMERIC(5,1),          -- average body length in metres
    avg_weight_kg NUMERIC(8,1),         -- average weight in kg
    discovered_year INT
);

-- Individual dinosaurs living in the park
CREATE TABLE IF NOT EXISTS dinosaurs (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    species_id INT          NOT NULL REFERENCES species(id),
    birth_year INT,
    enclosure  VARCHAR(50),
    status     VARCHAR(20)  NOT NULL DEFAULT 'alive'
                            CHECK (status IN ('alive', 'sick', 'escaped', 'deceased'))
);
