-- I am having some issues with my import I don't understand why I can't import the dates as yyyy-mm. The idea was to roll-up mort_delinq_stats_30_89_state and cpi to quarter when compare them.
-- It is not going as planned.  

SELECT * FROM mort_delinq_stats_30_89_state

--WHERE  region_type = 'National'
;

-- Something is going on at the national level



/*
SELECT
    CONCAT(EXTRACT(YEAR FROM TO_DATE(year_month, 'DD-MON-YY')), '-', EXTRACT(QUARTER FROM TO_DATE(year_month, 'DD-MON-YY'))) AS sales_quarter,
    AVG(delinq_stats_30_89) AS average_delinquency
FROM
    mort_delinq_stats_30_89_state
GROUP BY
    CONCAT(EXTRACT(YEAR FROM TO_DATE(year_month, 'DD-MON-YY')), '-', EXTRACT(QUARTER FROM TO_DATE(year_month, 'DD-MON-YY')))
ORDER BY
    sales_quarter;
*/

--roll-up delinq_stats_30_89 table to quarter
SELECT
    TO_CHAR(year_month, 'YYYY') || '-Q' || TO_CHAR(year_month, 'Q') AS cpi_quarter,
    AVG(delinq_stats_30_89) AS average_delinquency
FROM
    cpi
GROUP BY
    TO_CHAR(year_month, 'YYYY') || '-Q' || TO_CHAR(cpi_date, 'Q')
ORDER BY
    cpi_quarter;
    
    

SELECT
    'National' AS region_type
    ,ROUND(AVG(delinq_stats_30_89),2) AS average_delinquency
    ,year_month
    
FROM
    mort_delinq_stats_30_89_state
GROUP BY
   year_month
ORDER BY
    year_month;
    
    
SELECT COUNT(*) FROM mort_delinq_stats_30_89_state;

--DROP TABLE mort_delinq_stats_30_89_state;
--DROP TABLE cpi;


SELECT * FROM cpi

;

SELECT
    CONCAT(EXTRACT(YEAR FROM TO_DATE(cpi_date, 'DD-MON-YY')), '-', EXTRACT(QUARTER FROM TO_DATE(cpi_date, 'DD-MON-YY'))) AS cpi_quarter,
    AVG(cpiaucsl) AS average_cpi
FROM
    cpi
GROUP BY
    cpi_quarter;
    
    
    
--roll-up cpi table to quarter
SELECT
    TO_CHAR(cpi_date, 'YYYY') || '-Q' || TO_CHAR(cpi_date, 'Q') AS cpi_quarter,
    AVG(cpiaucsl) AS average_cpi
FROM
    cpi
GROUP BY
    TO_CHAR(cpi_date, 'YYYY') || '-Q' || TO_CHAR(cpi_date, 'Q')
ORDER BY
    cpi_quarter;

    
    
--cartesian join
SELECT *
FROM mort_delinq_stats_30_89_state
CROSS JOIN cpi
ORDER BY cpi_date;


