-- This README outlines the process of preparing a dataset for further analysis. The procedures involve creating specific tables within the 'nasa' schema, loading relevant data from CSV files into these tables, restructuring the tables by dropping, adding, and modifying columns and constraints, and finally, converting a specific text column into a date format. These steps collectively enhance the usability and query performance of the data stored in the 'nasa' schema.

-- The given code is creating two database tables for storing data related to NASA observations and locations.

-- THE FIRST SET

CREATE TABLE nasa.observation (
    brightness DOUBLE,
    scan DOUBLE,
    track DOUBLE,
    instrument TEXT,
    confidence INT,
    version DOUBLE,
    bright_t31 DOUBLE,
    frp DOUBLE,
    type_1 INT
);
CREATE TABLE nasa.location (
    latitude DOUBLE,
    longitude DOUBLE,
    acq_date text, 
    acq_time INT,
    satellite TEXT,
    daynight TEXT
);

-- The provided SQL code retrieves the system variable 'secure_file_priv' to determine the directory for file access. 
-- It then loads data from 'observation.csv' and 'location.csv' into the 'nasa.observation' and 'nasa.location' tables, respectively. 

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/observation.csv'
INTO TABLE nasa.observation
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/location.csv'
INTO TABLE nasa.location
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- THE SECOND SET

-- The script alters the 'nasa' schema by removing specific columns and foreign key constraints, modifying the structure of 'observation' and 'location' tables.

-- SELECT 
--  TABLE_NAME,COLUMN_NAME,CONSTRAINT_NAME, REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME
-- FROM
--   INFORMATION_SCHEMA.KEY_COLUMN_USAGE
-- WHERE
  -- REFERENCED_TABLE_SCHEMA = 'nasa' AND
--   REFERENCED_TABLE_NAME = 'location' AND
--  TABLE_NAME = 'observation';
-- ALTER TABLE nasa.observation DROP FOREIGN KEY observation_ibfk_1;

-- ALTER TABLE nasa.location DROP COLUMN location_id;
-- ALTER TABLE nasa.observation DROP COLUMN location_id;
-- ALTER TABLE nasa.observation DROP COLUMN observation_id;

-- This script adds new columns to the 'location' and 'observation' tables in the 'nasa' schema, sets them as primary keys, 
-- and establishes a foreign key relationship between them. The new columns are also populated with sequentially increasing integer values.

ALTER TABLE nasa.location ADD COLUMN location_id INT;
ALTER TABLE nasa.observation ADD COLUMN observation_id INT;
ALTER TABLE nasa.observation ADD COLUMN location_id INT;

SET sql_safe_updates=0;

SET @row_num = 0;
UPDATE nasa.location 
SET location_id = (@row_num := @row_num + 1)
WHERE (SELECT @row_num) IS NOT NULL;

SET @row_num = 0;
UPDATE nasa.observation 
SET observation_id = (@row_num := @row_num + 1),
location_id = observation_id
WHERE (SELECT @row_num) IS NOT NULL;

ALTER TABLE nasa.location MODIFY COLUMN location_id INT NOT NULL;
ALTER TABLE nasa.location ADD PRIMARY KEY (location_id);

ALTER TABLE nasa.observation MODIFY COLUMN observation_id INT NOT NULL;
ALTER TABLE nasa.observation ADD PRIMARY KEY (observation_id);

ALTER TABLE nasa.observation MODIFY COLUMN location_id INT NOT NULL;
ALTER TABLE nasa.observation ADD FOREIGN KEY (location_id) REFERENCES nasa.location(location_id);

DESCRIBE location;
DESCRIBE observation;
SHOW CREATE TABLE observation;

-- The aim of these commands is to modify the 'acq_date' column in the 'location' table of the 'nasa' database, converting it from a text type to a date type, 
-- to enable date-specific queries and improve data handling. Date Conversion: The command STR_TO_DATE(acq_date, '%d/%m/%Y') is used to convert the date strings 
-- in 'acq_date' from their existing format ('DD/MM/YYYY') to the standard MySQL date format ('YYYY-MM-DD').

UPDATE nasa.location
SET acq_date = STR_TO_DATE(acq_date, '%d/%m/%Y')
WHERE STR_TO_DATE(acq_date, '%d/%m/%Y') IS NOT NULL;
ALTER TABLE nasa.location 
CHANGE COLUMN acq_date acq_date DATE NULL DEFAULT NULL;

