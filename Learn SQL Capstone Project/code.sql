SELECT COUNT (DISTINCT utm_campaign) as Campaigns
FROM page_visits;

SELECT COUNT(DISTINCT utm_source) as Sources
FROM page_visits;
 
SELECT DISTINCT utm_campaign as Campaigns, 
								utm_source as Sources
FROM page_visits;

SELECT DISTINCT page_name as "Page Name"
FROM page_visits;
/*Here's the first-touch query, in case you need it
*/

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
	       pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source as Source,
			 ft_attr.utm_campaign as Campaign,
       COUNT (*) as Count
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;


WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
	       pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source as Source,
			 lt_attr.utm_campaign as Campaign,
       COUNT (*) as Count
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

SELECT COUNT (DISTINCT user_id) as Purchases
FROM page_visits
WHERE page_name = '4 - purchase';

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
	       pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source as Source,
			 lt_attr.utm_campaign as Campaign,
       COUNT (*) as Purchases
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;