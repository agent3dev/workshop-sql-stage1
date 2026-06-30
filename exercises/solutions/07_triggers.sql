-- Solutions: Triggers open challenges

-- E1. Auto-set birth_year if not provided
CREATE OR REPLACE FUNCTION set_default_birth_year()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.birth_year IS NULL THEN
        NEW.birth_year := EXTRACT(YEAR FROM NOW())::INT;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_default_birth_year
BEFORE INSERT ON dinosaurs
FOR EACH ROW EXECUTE FUNCTION set_default_birth_year();

-- E2. Prevent updating a deceased dinosaur
CREATE OR REPLACE FUNCTION prevent_deceased_update()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status = 'deceased' THEN
        RAISE EXCEPTION 'Cannot update a deceased dinosaur: %', OLD.name;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_deceased_update
BEFORE UPDATE ON dinosaurs
FOR EACH ROW EXECUTE FUNCTION prevent_deceased_update();

-- E3. Log deletions
CREATE TABLE IF NOT EXISTS deletions_log (
    id          SERIAL PRIMARY KEY,
    dino_name   TEXT,
    species_id  INT,
    deleted_at  TIMESTAMP DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION log_deletion()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO deletions_log (dino_name, species_id)
    VALUES (OLD.name, OLD.species_id);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_deletion
AFTER DELETE ON dinosaurs
FOR EACH ROW EXECUTE FUNCTION log_deletion();
