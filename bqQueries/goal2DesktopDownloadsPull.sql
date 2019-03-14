-- Downloads By landing page

SELECT
  date as date,
  SUM(IF(downloads > 0,1,0)) as downloads,
  SUM(IF(downloads > 0 AND browser != 'Firefox',1,0)) as nonFXDownloads
FROM (SELECT
  date AS date,
  fullVisitorId as visitorId,
  visitNumber as visitNumber,
  CASE WHEN hits.isEntrance IS TRUE THEN page.pagePath END as landingPage,
  trafficSource.source as source,
  device.browser as browser,
  device.browserVersion as browserVersion,
  device.operatingSystem as operatingSystem,
  geoNetwork.country AS country,
  SUM(IF (hits.eventInfo.eventAction = "Firefox Download",1,0)) as downloads
FROM
  `ga-mozilla-org-prod-001.65789850.ga_sessions_*`,
  UNNEST (hits) AS hits
WHERE
  _TABLE_SUFFIX >= '20170401'
  AND _TABLE_SUFFIX <= '20170515'
  AND hits.type = 'EVENT'
  AND hits.eventInfo.eventCategory IS NOT NULL
  AND hits.eventInfo.eventLabel LIKE "Firefox for Desktop%"
GROUP BY
  1,2,3,4,5,6,7,8,9)
GROUP BY 1
ORDER BY 1

-- General Downloads Pull
SELECT
  date as date,
  SUM(IF(downloads > 0,1,0)) as downloads,
  SUM(IF(downloads > 0 AND browser != 'Firefox',1,0)) as nonFXDownloads
FROM (SELECT
  date AS date,
  fullVisitorId as visitorId,
  visitNumber as visitNumber,
  trafficSource.source as source,
  device.browser as browser,
  SUM(IF (hits.eventInfo.eventAction = "Firefox Download",1,0)) as downloads
FROM
  `ga-mozilla-org-prod-001.65789850.ga_sessions_*`,
  UNNEST (hits) AS hits
WHERE
  _TABLE_SUFFIX >= '20170101'
  AND hits.type = 'EVENT'
  AND hits.eventInfo.eventCategory IS NOT NULL
  AND hits.eventInfo.eventLabel LIKE "Firefox for Desktop%"
GROUP BY
  1,2,3,4,5)
GROUP BY 1
ORDER BY 1
