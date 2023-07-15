# Vehicle Emissions Analysis: Fuel Consumption and CO2 Emissions Range in Canadian Vehicle Classes

## Problem Statement

We have data about vehicle emissions in Canada, spanning multiple vehicle classes, makes, and fuel consumption ratings. Our task is to analyze this data to derive insights regarding average fuel consumption and CO2 emissions across various vehicle classes. Additionally, we want to understand the range of these factors within each class, identify those with significant variability, and sort them based on their average fuel consumption and CO2 emissions.

## Objectives

1. Determine the number of vehicles in each vehicle class.
2. Calculate the average, minimum, and maximum fuel consumption and CO2 emissions for each vehicle class.
3. Evaluate the range of fuel consumption and CO2 emissions within each vehicle class.
4. Categorize the vehicle classes into 'Significant' and 'Insignificant' based on their fuel consumption and CO2 emissions range.
5. Filter out only those classes with significant ranges (greater than 5.0 for fuel consumption or greater than 50.0 for CO2 emissions).
6. Sort the resulting data by average fuel consumption and CO2 emissions in ascending order.

## Step-by-step Explanation

1. Select the necessary columns from the joined tables 'co2_emissions_canada_vehicle' and 'co2_emissions_canada_emission' based on the 'make' column.

2. Aggregate the data by 'Vehicle Class' using the GROUP BY clause.

3. Count the number of vehicles in each class, compute the average, minimum, and maximum fuel consumption and CO2 emissions for each class, and calculate the range of these factors.

4. Determine the categories ('Significant' or 'Insignificant') for each class based on their fuel consumption and CO2 emissions range using the CASE WHEN statement.

5. Apply a HAVING clause to filter out only those vehicle classes that have a significant fuel consumption or CO2 emissions range.

6. Finally, sort the resulting data in ascending order by the average fuel consumption and CO2 emissions using the ORDER BY clause.

