WITH data as(
SELECT
fetchData.Adname as fetchAdName,
adDetails.Device as device,
adDetails.OperatingSystem as OperatingSystem,
fetchData.vendorNetSpend as vendorNetSpend,
fetchData.downloadsGA as fetchDownloadsGA,
GA.content as gaContent,
GA.downloads as gaDownloads,
GA.nonFXDownloads as gaNonFXDownloads
FROM(
(SELECT
  Adname,
  SUM(vendorNetSpend) AS vendorNetSpend,
  SUM(DownloadsGA) AS downloadsGA
FROM
  `ga-mozilla-org-prod-001.fetch.fetch_deduped`
WHERE
  Date >= '2018-06-01'
  AND DATE <= '2018-06-30'
GROUP BY
  1
ORDER BY 2 DESC) as fetchData

LEFT JOIN

(SELECT
  content,
  SUM(IF(downloads > 0,1,0)) as downloads,
  SUM(IF(downloads > 0 AND browser != 'Firefox',1,0)) as nonFXDownloads
FROM (SELECT
  date AS date,
  fullVisitorId as visitorId,
  visitNumber as visitNumber,
  trafficSource.adcontent as content,
  device.browser as browser,
  SUM(IF (hits.eventInfo.eventAction = "Firefox Download",1,0)) as downloads
FROM
  `ga-mozilla-org-prod-001.65789850.ga_sessions_*`,
  UNNEST (hits) AS hits
WHERE
  _TABLE_SUFFIX >= '20180601'
  AND _TABLE_SUFFIX >= '20180630'
  AND hits.type = 'EVENT'
  AND hits.eventInfo.eventCategory IS NOT NULL
  AND hits.eventInfo.eventLabel LIKE "Firefox for Desktop%"
GROUP BY
  1,2,3,4,5)
GROUP BY 1
ORDER BY 2 DESC) as GA

ON fetchData.Adname = GA.content

LEFT JOIN

(SELECT
  Adname,
  Device,
  OperatingSystem
FROM
  `ga-mozilla-org-prod-001.fetch.fetch_deduped`
WHERE
  Date >= '2018-06-01'
  AND DATE <= '2018-06-30'
GROUP BY
  1,2,3
ORDER BY 2 DESC) as adDetails

ON fetchData.Adname = adDetails.Adname))

SELECT * FROM data
WHERE gaContent IS NULL
AND device = 'Desktop'
ORDER BY vendorNetSpend DESC