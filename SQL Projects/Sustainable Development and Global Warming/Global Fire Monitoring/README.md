Problem Statement:
Global fire monitoring is an important task for understanding the impact of wildfires on ecosystems, climate change, and human health. With increasing environmental changes, it's crucial to identify fire patterns across different regions and seasons. However, this can be a complex task due to the vastness of data available, differing satellite readings, and varying fire types.

The problem is to accurately identify, classify, and understand fire patterns based on a massive amount of data from NASA. It requires creating an algorithm that can sift through this data, identify regions based on latitude, evaluate fire frequency and intensity, and then rank each observation based on fire intensity. This information will be aggregated monthly and categorized by different regions, satellites, times of day (day/night), and fire types. The main challenge is to develop a consistent and accurate method for assessing fire activity across different parameters and providing meaningful insights to stakeholders.


Objectives:
1. Identify patterns of fire activity in different regions across the globe, as observed by NASA satellites, to facilitate global fire tracking and response mechanisms.
2. Evaluate the intensity and frequency of fires using parameters like brightness, fire radiative power (FRP), and confidence levels provided by NASA data.
3. Develop a ranking mechanism to categorize fire intensity based on average monthly brightness, FRP, and confidence.
4. Produce a comprehensive report to provide insights on monthly fire activities, highlighting regions with the highest intensity and frequency of fires.


STEP BY STEP PROCESS
1. Use the appropriate NASA database.

2. Identify and classify the region based on latitude:
   - If latitude <= -66.56, then it is an 'Antarctic Region'.
   - If latitude is between -66.56 and -23.44, then it is a 'Southern Temperate Region'.
   - If latitude is between -23.44 and 23.44, then it is a 'Tropical Region'.
   - If latitude is between 23.44 and 66.56, then it is a 'Northern Temperate Region'.
   - Else, it is an 'Arctic Region'.

3. For each region, day, satellite, time of day (day or night), and fire type, calculate the following for observations with a confidence value above 30:
   - The number of fires (`daily_fire_count`).
   - The average brightness (`avg_daily_brightness`).
   - The average brightness in the mid-infrared wavelength (`avg_daily_bright_t31`).
   - The average fire radiative power (`avg_daily_frp`).
   - The average confidence (`avg_daily_confidence`).

4. Calculate the monthly aggregates for each region, satellite, time of day (day or night), and fire type:
   - The number of fires (`monthly_fire_count`).
   - The average brightness (`avg_monthly_brightness`).
   - The average brightness in the mid-infrared wavelength (`avg_monthly_bright_t31`).
   - The average fire radiative power (`avg_monthly_frp`).
   - The average confidence (`avg_monthly_confidence`).

5. Rank each region, satellite, time of day (day or night), and fire type based on their average monthly brightness, fire radiative power, and confidence.

6. Assign a label to each rank:
   - The highest rank (1) is labelled 'Highest'.
   - The second highest rank (2) is labelled 'High'.
   - The third highest rank (3) is labelled 'Moderate'.
   - All others are labelled 'Low'.

7. Finally, create a report showing for each region, satellite, time of day (day or night), and fire type, the year, month, monthly fire count, average monthly brightness, brightness in the mid-infrared wavelength, fire radiative power, confidence, and the labels assigned to brightness, fire radiative power, and confidence levels.

Remember, the specifics might change depending on the available data and the specific requirements of the project.


Data Preparation:

Goal and Problem Statement for the First Set of SQL Commands:
Problem Statement: The key problem these commands are attempting to solve is the need to store and manage large volumes of observational and locational data from CSV files in a structured manner in a MySQL database. The challenge is to ensure that data from each CSV file is imported correctly into its corresponding table. There may be potential issues with data types, file paths, and file permissions that could complicate the data import process.

Goal: The goal of this first set of SQL commands is to create two tables named "observation" and "location" in a database named "nasa". It then uploads data from two separate CSV files, 'observation.csv' and 'location.csv', into these tables. The 'secure_file_priv' variable is checked to ensure that MySQL has the correct permissions to access and import data files.

Goal and Problem Statement for the Second Set of SQL Commands:
Problem Statement: The primary problem these commands aim to solve is the lack of unique identifiers and relationships between the "observation" and "location" tables. Unique identifiers are needed to efficiently query and manage data, while relationships between tables are crucial for data integrity and consistency. Challenges may arise in ensuring that each row in both tables is assigned a unique identifier and that the foreign key relationship is correctly set up to ensure data integrity.

Goal: The goal of the second set of SQL commands is to add primary key and foreign key constraints to the "observation" and "location" tables. Primary key columns 'location_id' and 'observation_id' are added and populated with unique identifiers for each row. A foreign key constraint is added to the "observation" table that references the 'location_id' in the "location" table.

CODE DESCRIPTION:
The given code is creating two database tables for storing data related to NASA observations and locations.
The first table is named "nasa.observation" and has the following columns:
       - brightness (data type: DOUBLE): Represents the brightness value of the observation.
       - scan (data type: DOUBLE): Indicates the scan value of the observation.
       - track (data type: DOUBLE): Represents the track value of the observation.
       - instrument (data type: TEXT): Stores the instrument used for the observation.
       - confidence (data type: INT): Represents the confidence level associated with the observation.
       - version (data type: DOUBLE): Indicates the version of the observation.
       - bright_t31 (data type: DOUBLE): Represents the bright_t31 value of the observation.
       - frp (data type: DOUBLE): Indicates the frp (fire radiative power) value of the observation.
       - type_1 (data type: INT): Represents the type of the observation.
The second table is named "nasa.location" and has the following columns:
       - latitude (data type: DOUBLE): Represents the latitude of the location.
       - longitude (data type: DOUBLE): Indicates the longitude of the location.
       - acq_date (data type: TEXT): Stores the acquisition date of the observation.
       - acq_time (data type: INT): Represents the acquisition time of the observation.
       - satellite (data type: TEXT): Indicates the satellite used for the observation.
       - daynight (data type: TEXT): Represents whether the observation was made during the day or night.
These tables provide a structure for storing and organizing data related to NASA observations and their corresponding locations.
