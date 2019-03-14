-- Standard SQL
    -- Working with Dates
    PARSE_DATE('%Y%m%d', downloadDate) -- Convert date stored as string to date type
    FORMAT_DATE('%Y%m%d', downloadDate) -- Convert date stored as date to string
    FORMAT_DATE("%Y%m",PARSE_DATE("%Y%m%d",acquisitionDate)) IN ("201712", "201801")  -- combining the two for custom requests
    EXTRACT(Date FROM submission_date_s3) -- Pulling date from a timestamp. Also works for month, year etc.
    FORMAT_DATE('%Y%m%d', CURRENT_DATE()) -- converting current date to string


    -- Rounding
    ROUND(SUM(VendorNetSpend),2) AS vendorNetSpend -- Round to two decimal places. Nothing after , = round to integer

    -- Calculating % of total


IFNULL(priorMonth.dau,0) as priorMonthDau -- populats null with a different value
SAFE_DIVIDE(currentYear.aDAUMetric, priorYear.aDAUMetric) -- avoids division by zero errors

    -- Creating partitions and calculating averages over a period
    ROUND(AVG(aDAU) OVER (ORDER BY submissionDate ROWS BETWEEN 27 PRECEDING AND CURRENT ROW)) AS DAU28Day,


-- Legacy SQL