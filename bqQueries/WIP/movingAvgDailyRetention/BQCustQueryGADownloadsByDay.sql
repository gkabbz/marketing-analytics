-- data source for trended graph under mozilla funnel in 28 Day Mvg Avg Acquisition & Retention Summary Dashboard: https://datastudio.google.com/reporting/153_dIAClfvYQ1woP-YTtO3cR6Rqt-3yJ/page/wN8V/edit

SELECT
date,
downloads,
ROUND(AVG(downloads) OVER (ORDER BY date ROWS BETWEEN 27 PRECEDING AND CURRENT ROW)) AS downloads28DAYAvg,
nonFXDownloads,
ROUND(AVG(nonFXDownloads) OVER (ORDER BY date ROWS BETWEEN 27 PRECEDING AND CURRENT ROW)) AS nonFXDownloads28DAYAvg,
totalInstalls,
ROUND(AVG(totalInstalls) OVER (ORDER BY date ROWS BETWEEN 27 PRECEDING AND CURRENT ROW)) AS installs28DAYAvg
FROM `telemetry.acquisitionByDay`
WHERE date LIKE '2017%' OR date LIKE '2018%' OR date LIKE '2019%'
GROUP BY 1,2,4,6