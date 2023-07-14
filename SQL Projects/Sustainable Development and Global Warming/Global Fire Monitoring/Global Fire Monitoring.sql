USE nasa;

WITH region_classification AS (
    SELECT
        loc.location_id, 
        loc.latitude, 
        loc.longitude, 
        loc.acq_date, 
        loc.acq_time, 
        loc.satellite, 
        loc.daynight, 
        obs.observation_id, 
        obs.Brightness, 
        obs.scan, 
        obs.track, 
        obs.instrument, 
        obs.confidence, 
        obs.version, 
        obs.bright_t31, 
        obs.Frp, 
        obs.type_1,
        CASE
            WHEN loc.latitude <= -66.56 THEN 'Antarctic Region'
            WHEN loc.latitude BETWEEN -66.56 AND -23.44 THEN 'Southern Temperate Region'
            WHEN loc.latitude BETWEEN -23.44 AND 23.44 THEN 'Tropical Region'
            WHEN loc.latitude BETWEEN 23.44 AND 66.56 THEN 'Northern Temperate Region'
            ELSE 'Arctic Region'
        END AS region
    FROM 
        location AS loc
    JOIN 
        observation AS obs ON loc.location_id = obs.location_id 
),
daily_fire_activity AS (
    SELECT 
        rc.acq_date, 
        rc.region, 
        rc.satellite,
        rc.daynight,
        rc.type_1,
        COUNT(*) OVER (PARTITION BY rc.region, rc.acq_date, rc.satellite, rc.daynight, rc.type_1) AS daily_fire_count, 
        AVG(rc.brightness) OVER (PARTITION BY rc.region, rc.acq_date, rc.satellite, rc.daynight, rc.type_1) AS avg_daily_brightness, 
        AVG(rc.bright_t31) OVER (PARTITION BY rc.region, rc.acq_date, rc.satellite, rc.daynight, rc.type_1) AS avg_daily_bright_t31, 
        AVG(rc.Frp) OVER(PARTITION BY rc.region, rc.acq_date, rc.satellite, rc.daynight, rc.type_1) AS avg_daily_frp, 
        AVG(rc.confidence) OVER(PARTITION BY rc.region, rc.acq_date, rc.satellite, rc.daynight, rc.type_1) AS avg_daily_confidence 
    FROM 
        region_classification AS rc
    WHERE 
        rc.confidence > 30
),
monthly_fire_activity AS (
    SELECT 
       EXTRACT(YEAR FROM dfa.acq_date) AS year_, 
        EXTRACT(MONTH FROM dfa.acq_date) AS month_, 
        dfa.region,
        dfa.satellite,
        dfa.daynight,
        dfa.type_1,
        COUNT(*) AS monthly_fire_count, 
        AVG(dfa.avg_daily_brightness) AS avg_monthly_brightness, 
        AVG(dfa.avg_daily_bright_t31) AS avg_monthly_bright_t31, 
        AVG(dfa.avg_daily_frp) AS avg_monthly_frp, 
        AVG(dfa.avg_daily_confidence) AS avg_monthly_confidence
    FROM 
        daily_fire_activity AS dfa
    GROUP BY 
        year_, 
        month_, 
        dfa.region,
        dfa.satellite,
        dfa.daynight,
        dfa.type_1
),
region_ranks AS (
    SELECT 
        mfa.year_,
        mfa.month_,
        mfa.region,
        mfa.satellite,
        mfa.daynight,
        mfa.type_1,
        mfa.monthly_fire_count,
        mfa.avg_monthly_brightness,
        mfa.avg_monthly_bright_t31,
        mfa.avg_monthly_frp,
        mfa.avg_monthly_confidence,
        RANK() OVER(PARTITION BY mfa.region, mfa.satellite, mfa.daynight, mfa.type_1 ORDER BY mfa.avg_monthly_brightness DESC) as brightness_rank,
        RANK() OVER(PARTITION BY mfa.region, mfa.satellite, mfa.daynight, mfa.type_1 ORDER BY mfa.avg_monthly_frp DESC) as frp_rank,
        RANK() OVER(PARTITION BY mfa.region, mfa.satellite, mfa.daynight, mfa.type_1 ORDER BY mfa.avg_monthly_confidence DESC) as confidence_rank
    FROM 

        monthly_fire_activity AS mfa
)
SELECT
    rr.year_,
    rr.month_,
    rr.region,
    rr.satellite,
    rr.daynight,
    rr.type_1,
    rr.monthly_fire_count,
    rr.avg_monthly_brightness,
    rr.avg_monthly_bright_t31,
    rr.avg_monthly_frp,
    rr.avg_monthly_confidence,
    CASE
        WHEN rr.brightness_rank = 1 THEN 'Highest'
        WHEN rr.brightness_rank = 2 THEN 'High'
        WHEN rr.brightness_rank = 3 THEN 'Moderate'
        ELSE 'Low'
    END AS brightness_level,
   
    CASE
        WHEN rr.frp_rank = 1 THEN 'Highest'
        WHEN rr.frp_rank = 2 THEN 'High'
        WHEN rr.frp_rank = 3 THEN 'Moderate'
        ELSE 'Low'
    END AS frp_level,
    CASE
        WHEN rr.confidence_rank = 1 THEN 'Highest'
        WHEN rr.confidence_rank = 2 THEN 'High'
        WHEN rr.confidence_rank = 3 THEN 'Moderate'
        ELSE 'Low'
    END AS confidence_level
FROM 
    region_ranks AS rr;
