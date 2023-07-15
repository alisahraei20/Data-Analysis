
/* Vehicle Emissions Analysis*/

SELECT
    A.`Vehicle Class`,
    COUNT(*) AS NumVehicles,
    ROUND(AVG(B.`Fuel Consumption Comb (L/100 km)`)) AS AvgFuelConsumption,
    MIN(B.`Fuel Consumption Comb (L/100 km)`) AS MinFuelConsumption,
    MAX(B.`Fuel Consumption Comb (L/100 km)`) AS MaxFuelConsumption,
    AVG(B.`CO2 Emissions (g/km)`) AS AvgCO2Emissions,
    MIN(B.`CO2 Emissions (g/km)`) AS MinCO2Emissions,
    MAX(B.`CO2 Emissions (g/km)`) AS MaxCO2Emissions,
    ROUND((MAX(B.`Fuel Consumption Comb (L/100 km)`) - MIN(B.`Fuel Consumption Comb (L/100 km)`))) AS FuelConsumptionRange,
    (MAX(B.`CO2 Emissions (g/km)`) - MIN(B.`CO2 Emissions (g/km)`)) AS CO2EmissionsRange,
    CASE
        WHEN (MAX(B.`Fuel Consumption Comb (L/100 km)`) - MIN(B.`Fuel Consumption Comb (L/100 km)`)) > 5.0 THEN 'Significant Fuel Consumption Range'
        ELSE 'Insignificant Fuel Consumption Range'
    END AS FuelConsumptionRangeCategory,
    CASE
        WHEN (MAX(B.`CO2 Emissions (g/km)`) - MIN(B.`CO2 Emissions (g/km)`)) > 50.0 THEN 'Significant CO2 Emissions Range'
        ELSE 'Insignificant CO2 Emissions Range'
    END AS CO2EmissionsRangeCategory
FROM
    co2_emissions_canada_vehicle A
    INNER JOIN co2_emissions_canada_emission B ON A.`make` = B.`make`
WHERE
    (B.`Fuel Consumption Comb (L/100 km)`, B.`CO2 Emissions (g/km)`) IN (
        SELECT
            MIN(`Fuel Consumption Comb (L/100 km)`),
            MIN(`CO2 Emissions (g/km)`)
        FROM
            co2_emissions_canada_emission
        GROUP BY
            `make`
    )
GROUP BY
    A.`Vehicle Class`
HAVING
    FuelConsumptionRange > 5.0
    OR CO2EmissionsRange > 50.0
ORDER BY
    AvgFuelConsumption ASC, AvgCO2Emissions ASC;
