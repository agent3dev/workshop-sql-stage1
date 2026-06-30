-- =============================================================
--  DINOPARK  --  Exercise 1: SOLUTIONS
-- =============================================================

-- F1. How many species are herbivores?
SELECT COUNT(*) FROM species WHERE diet = 'herbivore';

-- F2. List every dinosaur born after 2019.
SELECT name, birth_year FROM dinosaurs WHERE birth_year > 2019;

-- F3. Which enclosure has the most dinosaurs?
SELECT   enclosure, COUNT(*) AS total
FROM     dinosaurs
GROUP BY enclosure
ORDER BY total DESC
LIMIT 1;

-- F4. (example)
INSERT INTO dinosaurs (name, species_id, birth_year, enclosure, status)
VALUES ('Dino Jr.', 1, 2024, 'North Paddock', 'alive');
