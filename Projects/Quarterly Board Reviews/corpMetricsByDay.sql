WITH data AS (
  SELECT
  submission_date_s3 AS submissionDate,
  funnelOrigin AS funnelOrigin,
  sum(DAU) as DAU,
  SUM(DAU)*0.75 as aDAUCalculated,
  sum(activeDAU) as aDAU,
  sum(installs) as installs,
  sum(searches) as searches
FROM
  `ga-mozilla-org-prod-001.telemetry.corpMetrics`
GROUP By 1,2
UNION ALL
SELECT
  submission_date_s3 AS submissionDate,
  'total' AS funnelOrigin,
  sum(DAU) as DAU,
  SUM(DAU)*0.75 as aDAUCalculated,
  sum(activeDAU) as aDAU,
  sum(installs) as installs,
  sum(searches) as searches
FROM
  `ga-mozilla-org-prod-001.telemetry.corpMetrics`
GROUP By 1,2
ORDER BY 2,1)

SELECT
  submissionDate,
  funnelOrigin,
  DAU,
  aDAUCalculated,
  aDAU,
  installs,
  searches,
  ROUND(AVG(DAU) OVER (ORDER BY funnelOrigin, submissionDate ROWS BETWEEN 27 PRECEDING AND CURRENT ROW)) AS DAU28Day,
  ROUND(AVG(aDAUCalculated) OVER (ORDER BY funnelOrigin, submissionDate ROWS BETWEEN 27 PRECEDING AND CURRENT ROW)) AS aDAUCalculated28Day,
  ROUND(AVG(aDAU) OVER (ORDER BY funnelOrigin, submissionDate ROWS BETWEEN 27 PRECEDING AND CURRENT ROW)) AS aDAU28Day,
  ROUND(AVG(DAU) OVER (ORDER BY funnelOrigin, submissionDate ROWS BETWEEN 90 PRECEDING AND CURRENT ROW)) AS DAU91Day,
  ROUND(AVG(aDAUCalculated) OVER (ORDER BY funnelOrigin, submissionDate ROWS BETWEEN 90 PRECEDING AND CURRENT ROW)) AS aDAUCalculated91Day,
  ROUND(AVG(aDAU) OVER (ORDER BY funnelOrigin, submissionDate ROWS BETWEEN 90 PRECEDING AND CURRENT ROW)) AS aDAU91Day,
  SUM(CASE WHEN funnelOrigin = 'mozFunnel' THEN installs ELSE 0 END) as mktgAttrInstalls,
  SUM(CASE WHEN funnelOrigin = 'darkFunnel' THEN installs ELSE 0 END) as darkFunnelInstalls,
  SUM(CASE WHEN funnelOrigin = 'total' THEN installs ELSE 0 END) as totalInstalls
FROM data
GROUP BY 1,2,3,4,5,6,7