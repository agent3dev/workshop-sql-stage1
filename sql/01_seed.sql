-- =============================================================
--  DINOPARK DATABASE  --  Sample Data
-- =============================================================

INSERT INTO eras (name, started_mya, ended_mya) VALUES
    ('Triassic',   252, 201),
    ('Jurassic',   201, 145),
    ('Cretaceous', 145,  66);

INSERT INTO species (name, era_id, diet, avg_length_m, avg_weight_kg, discovered_year) VALUES
    -- Triassic (era_id = 1)
    ('Coelophysis',         1, 'carnivore',   3.0,   20.0, 1889),
    ('Plateosaurus',        1, 'herbivore',   8.0, 4000.0, 1837),
    ('Herrerasaurus',       1, 'carnivore',   6.0,  350.0, 1963),
    ('Eoraptor',            1, 'omnivore',    1.0,   10.0, 1991),
    -- Jurassic (era_id = 2)
    ('Brachiosaurus',       2, 'herbivore',  26.0, 56000.0, 1900),
    ('Stegosaurus',         2, 'herbivore',   9.0,  3500.0, 1877),
    ('Pterodactylus',       2, 'carnivore',   1.0,     5.0, 1784),
    ('Diplodocus',          2, 'herbivore',  27.0, 14000.0, 1878),
    ('Allosaurus',          2, 'carnivore',  12.0,  2000.0, 1877),
    ('Archaeopteryx',       2, 'carnivore',   0.5,     1.0, 1861),
    ('Compsognathus',       2, 'carnivore',   1.0,     3.0, 1859),
    ('Camarasaurus',        2, 'herbivore',  18.0, 20000.0, 1877),
    ('Ceratosaurus',        2, 'carnivore',   6.0,   500.0, 1884),
    ('Kentrosaurus',        2, 'herbivore',   4.5,   700.0, 1915),
    -- Cretaceous (era_id = 3)
    ('Tyrannosaurus Rex',   3, 'carnivore',  12.0,  8000.0, 1905),
    ('Triceratops',         3, 'herbivore',   9.0,  6000.0, 1889),
    ('Velociraptor',        3, 'carnivore',   2.0,    15.0, 1924),
    ('Ankylosaurus',        3, 'herbivore',   6.5,  6000.0, 1908),
    ('Spinosaurus',         3, 'carnivore',  15.0,  9000.0, 1915),
    ('Iguanodon',           3, 'herbivore',  10.0,  3000.0, 1825),
    ('Parasaurolophus',     3, 'herbivore',   9.5,  2500.0, 1922),
    ('Pachycephalosaurus',  3, 'herbivore',   4.5,   450.0, 1931),
    ('Carnotaurus',         3, 'carnivore',   8.0,  1500.0, 1984),
    ('Giganotosaurus',      3, 'carnivore',  13.0,  8000.0, 1995),
    ('Deinonychus',         3, 'carnivore',   3.4,    73.0, 1969),
    ('Oviraptor',           3, 'omnivore',    2.0,    35.0, 1924),
    ('Maiasaura',           3, 'herbivore',   9.0,  2500.0, 1979),
    ('Styracosaurus',       3, 'herbivore',   5.5,  2700.0, 1913),
    ('Corythosaurus',       3, 'herbivore',   9.0,  4000.0, 1914),
    ('Therizinosaurus',     3, 'herbivore',  10.0,  5000.0, 1954);

INSERT INTO dinosaurs (name, species_id, birth_year, enclosure, status)
SELECT d.name, s.id, d.birth_year, d.enclosure, d.status
FROM (VALUES
    ('Rexy',        'Tyrannosaurus Rex',  2018, 'North Paddock',  'alive'),
    ('Chomp',       'Tyrannosaurus Rex',  2020, 'North Paddock',  'alive'),
    ('Trike',       'Triceratops',        2017, 'Valley Pen',     'alive'),
    ('Horns',       'Triceratops',        2019, 'Valley Pen',     'alive'),
    ('Blue',        'Velociraptor',       2021, 'Raptor Arena',   'alive'),
    ('Delta',       'Velociraptor',       2021, 'Raptor Arena',   'alive'),
    ('Echo',        'Velociraptor',       2021, 'Raptor Arena',   'escaped'),
    ('Benny',       'Brachiosaurus',      2015, 'Savanna Zone',   'alive'),
    ('Spike',       'Stegosaurus',        2016, 'Savanna Zone',   'sick'),
    ('Armory',      'Ankylosaurus',       2019, 'East Fortress',  'alive'),
    ('Longneck',    'Diplodocus',         2014, 'Savanna Zone',   'alive'),
    ('Spiny',       'Spinosaurus',        2020, 'Lagoon Sector',  'alive'),
    ('Iggy',        'Iguanodon',          2022, 'Valley Pen',     'alive'),
    ('Rex Jr.',     'Giganotosaurus',     2021, 'North Paddock',  'alive'),
    ('Crest',       'Parasaurolophus',    2020, 'Valley Pen',     'alive'),
    ('Dagger',      'Deinonychus',        2022, 'Raptor Arena',   'alive'),
    ('Bonehead',    'Pachycephalosaurus', 2019, 'East Fortress',  'alive'),
    ('Mama',        'Maiasaura',          2016, 'Savanna Zone',   'alive'),
    ('Tiny',        'Archaeopteryx',      2023, 'Aviary Dome',    'alive'),
    ('Feathers',    'Compsognathus',      2023, 'Aviary Dome',    'alive'),
    ('Clawzilla',   'Therizinosaurus',    2018, 'Savanna Zone',   'alive'),
    ('Phantom',     'Coelophysis',        2022, 'Triassic Wing',  'alive'),
    ('Atlas',       'Plateosaurus',       2017, 'Triassic Wing',  'alive')
) AS d(name, species_name, birth_year, enclosure, status)
JOIN species s ON s.name = d.species_name;
