# Global Fire Monitoring and Pattern Recognition

## Problem Statement:

Understanding and monitoring global fire activities is essential for discerning their impacts on ecosystems, climate change, and human health. In light of escalating environmental changes, it becomes critical to identify fire patterns spanning various regions and seasons. This task, however, is intricate due to the enormity of available data, disparate satellite readings, and the diversity of fire types.

The task at hand involves accurately identifying, classifying, and understanding fire patterns based on extensive data sourced from NASA. This necessitates developing an algorithm capable of scrutinizing this data, discerning regions based on latitude, determining fire frequency and intensity, and subsequently ranking each observation premised on fire intensity. The insights gleaned will be aggregated monthly and categorized by distinct regions, satellites, times of day (day/night), and fire types. The primary challenge lies in devising a reliable and precise methodology for assessing fire activity across multiple parameters and rendering meaningful insights for stakeholders.

## Objectives:

1. Recognize patterns of fire activity across various regions worldwide, as reported by NASA satellites, to aid in global fire tracking and response mechanisms.
2. Evaluate fire intensity and frequency utilizing parameters such as brightness, fire radiative power (FRP), and confidence levels provided in the NASA data.
3. Establish a ranking mechanism to categorize fire intensity based on average monthly brightness, FRP, and confidence.
4. Generate a comprehensive report to provide insights on monthly fire activities, emphasizing regions with the highest fire intensity and frequency.

## Step-by-Step Process:

1. Leverage the appropriate NASA database.
2. Determine and classify the region based on latitude:
   - `Antarctic Region` for latitude <= -66.56.
   - `Southern Temperate Region` for latitude between -66.56 and -23.44.
   - `Tropical Region` for latitude between -23.44 and 23.44.
   - `Northern Temperate Region` for latitude between 23.44 and 66.56.
   - `Arctic Region` for latitude > 66.56.
3. For each region, day, satellite, time of day (day/night), and fire type, calculate the following for observations with a confidence value above 30:
   - Number of fires (`daily_fire_count`).
   - Average brightness (`avg_daily_brightness`).
   - Average brightness in the mid-infrared wavelength (`avg_daily_bright_t31`).
   - Average fire radiative power (`avg_daily_frp`).
   - Average confidence (`avg_daily_confidence`).
4. Compute the monthly aggregates for each region, satellite, time of day (day/night), and fire type:
   - Number of fires (`monthly_fire_count`).
   - Average brightness (`avg_monthly_brightness`).
   - Average brightness in the mid-infrared wavelength (`avg_monthly_bright_t31`).
   - Average fire radiative power (`avg_monthly_frp`).
   - Average confidence (`avg_monthly_confidence`).
5. Rank each region, satellite, time of day (day/night), and fire type based on their average monthly brightness, fire radiative power, and confidence.
6. Assign a label to each rank:
   - Rank 1: `Highest`
   - Rank 2: `High`
   - Rank 3: `Moderate`
   - Others: `Low`
7. Finally, generate a report showcasing each region, satellite, time of day (day/night), and fire type, including the year, month, monthly fire count, average monthly brightness, brightness in the mid-infrared wavelength, fire radiative power, confidence, and the labels assigned to brightness, fire radiative power, and confidence levels.

## Data Preparation:

### First Set of SQL Commands:

**Problem Statement**: The initial challenge lies in storing and managing substantial observational and locational data from CSV files in a MySQL database in a structured manner. It is essential to ensure correct importation of data from each CSV file into its corresponding table, which may be complicated due to potential issues with data types, file paths, and file permissions.

**Goal**: The objective of the first set of SQL commands is to create two tables: "observation" and "location" in a database named "nasa". Following this, data from two separate CSV files, 'observation.csv' and 'location.csv', are uploaded into these tables. The 'secure_file_priv' variable is inspected to verify that MySQL has the appropriate permissions to access and import data files.

### Second Set of SQL Commands:

**Problem Statement**: The primary issue addressed by these commands is the absence of unique identifiers and relationships between the "observation" and "location" tables. Unique identifiers are necessary for efficient data querying and management, while relationships between tables are crucial for data integrity and consistency.

**Objectives**: The second set of SQL commands aims to add primary key and foreign key constraints to the "observation" and "location" tables. Primary key columns 'location_id' and 'observation_id' are added and populated with unique identifiers for each row. A foreign key constraint is added to the "observation" table that references the 'location_id' in the "location" table.



# Database Structure for NASA Fire Observations and Locations

## Description:

The given code constructs two relational database tables intended to store data pertinent to NASA's fire observations and associated locations. 

## Table Structures:

### 1. `nasa.observation`

This table is designated for storing data related to the fire observations, and it comprises the following columns:

- `brightness` (data type: DOUBLE): This represents the brightness value of a particular observation.
- `scan` (data type: DOUBLE): This indicates the scan value for the observation.
- `track` (data type: DOUBLE): This column contains the track value for the observation.
- `instrument` (data type: TEXT): This stores the name or type of instrument used for the observation.
- `confidence` (data type: INT): This column holds the confidence level associated with the observation.
- `version` (data type: DOUBLE): This indicates the version of the observation data.
- `bright_t31` (data type: DOUBLE): This holds the value of bright_t31 for the observation.
- `frp` (data type: DOUBLE): This column contains the fire radiative power (frp) value of the observation.
- `type_1` (data type: INT): This column signifies the type of the observation.

### 2. `nasa.location`

This table is dedicated to storing data related to the locations of the fire observations, and it includes the following columns:

- `latitude` (data type: DOUBLE): This represents the latitude of the location where the observation was made.
- `longitude` (data type: DOUBLE): This indicates the longitude of the location where the observation took place.
- `acq_date` (data type: TEXT): This column stores the acquisition date of the observation.
- `acq_time` (data type: INT): This represents the acquisition time of the observation.
- `satellite` (data type: TEXT): This indicates the satellite that was used for the observation.
- `daynight` (data type: TEXT): This column specifies whether the observation was made during the day or at night.

Both of these tables collectively create a structured environment for storing and organizing data pertinent to NASA's fire observations and their corresponding locations. This architecture aids in efficient querying, data integrity, and analysis.



# Output of the code

![WhatsApp Image 2023-07-15 at 10 06 47 PM](https://github.com/alisahraei20/Data-Analysis/assets/134171185/bc67272a-621c-4265-bc22-d6009bd8a06f)

