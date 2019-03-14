--Marketing Attributable Clients by country
--Includes traffic that belongs to a known marketing attributable medium (cpc, paidsearch, email, snippet, video, native, display, social
--Excludes outliers where variance > 2.5 standard deviations from the mean


SELECT
--  avg(total_clv) avg_LTV, sum(total_clv)*100 sum_LTV, count(distinct(client_id)) n, count(distinct(client_id))*100 population

FROM
  `ltv.ltv_v1_backfilled`
WHERE
 (campaign like ('Firefox-Brand-US-GGL%') OR
  (campaign like ('Brand-US-GGL%'))
 AND 
-- Exclude outliers
 historical_searches < (
  SELECT
    STDDEV(historical_searches)
  FROM
    `ltv.ltv_v1_backfilled`) *2.5 + (
  SELECT
    AVG(historical_searches)
  FROM
    `ltv.ltv_v1_backfilled`)
