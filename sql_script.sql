# создание таблиц для нормализации

CREATE TABLE IF NOT EXISTS animal_type(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS animal_breed(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS animal_color(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS outcome_subtype(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS outcome_type(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL
);

# создание новой сводной таблицы

CREATE TABLE IF NOT EXISTS new_animals (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    animal_id VARCHAR(100) NOT NULL,
    age_upon_outcome VARCHAR(100) NOT NULL,
    name VARCHAR(100),
    date_of_birth TEXT NOT NULL,
    outcome_month INTEGER NOT NULL,
    outcome_year INTEGER NOT NULL,
    type_id INTEGER NOT NULL,
    breed_id INTEGER NOT NULL,
    color1_id INTEGER,
    color2_id INTEGER,
    outcome_subtype_id INTEGER,
    outcome_type_id INTEGER,

    FOREIGN KEY (type_id) REFERENCES animal_type(id),
    FOREIGN KEY (breed_id) REFERENCES animal_breed(id),
    FOREIGN KEY (color1_id) REFERENCES animal_color(id),
    FOREIGN KEY (color2_id) REFERENCES animal_color(id),
    FOREIGN KEY (outcome_subtype_id) REFERENCES outcome_subtype(id),
    FOREIGN KEY (outcome_type_id) REFERENCES outcome_type(id)
);

# перенос данных

INSERT INTO animal_type (name)
SELECT DISTINCT animal_type FROM animals;

INSERT INTO animal_breed (name)
SELECT DISTINCT breed FROM animals;

INSERT INTO animal_color (name)
SELECT DISTINCT TRIM(color1) as color FROM animals
UNION
SELECT DISTINCT TRIM(color2) as color FROM animals WHERE color2 IS NOT NULL;

INSERT INTO outcome_subtype (name)
SELECT DISTINCT outcome_subtype FROM animals WHERE outcome_subtype IS NOT NULL;

INSERT INTO outcome_type (name)
SELECT DISTINCT outcome_type FROM animals WHERE outcome_type IS NOT NULL;

INSERT INTO new_animals (
    age_upon_outcome,
    animal_id,
    name,
    date_of_birth,
    outcome_month,
    outcome_year,
    type_id,
    breed_id,
    color1_id,
    color2_id,
    outcome_subtype_id,
    outcome_type_id
)

SELECT
    age_upon_outcome,
    animal_id,
    animals.name,
    date_of_birth,
    outcome_month,
    outcome_year,
    animal_type.id as type_id,
    animal_breed.id as breed_id,
    animal_color1.id as color1_id,
    animal_color2.id as color2_id,
    outcome_subtype.id as outcome_subtype_id,
    outcome_type.id as outcome_type_id
FROM animals
LEFT JOIN animal_type
    ON animal_type.name = animals.animal_type
LEFT JOIN animal_breed
    ON animal_breed.name = animals.breed
LEFT JOIN animal_color as animal_color1
    ON animal_color1.name = animals.color1
LEFT JOIN animal_color as animal_color2
    ON animal_color2.name = animals.color2
LEFT JOIN outcome_subtype
    ON outcome_subtype.name = animals.outcome_subtype
LEFT JOIN outcome_type
    ON outcome_type.name = animals.outcome_type;