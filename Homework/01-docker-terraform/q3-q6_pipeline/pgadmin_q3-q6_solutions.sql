-- Question 3
SELECT 
	CASE 
		WHEN trip_distance <= 1 then '1 mile club'
		ELSE 'big hitters'
	END AS "trip_buckets",
	COUNT(*)
		
FROM 
	public.taxi_trips
WHERE 
	lpep_pickup_datetime >= '2025-11-01' AND
	lpep_pickup_datetime < '2025-12-01'
GROUP BY 1
;

-- Question 4

SELECT
	*
FROM public.taxi_trips
WHERE trip_distance =
	(SELECT 
		max(trip_distance)
	FROM 
		public.taxi_trips
	WHERE 
		trip_distance < 100)
;

-- Question 5
with nov_18_totals_by_zone AS (
	SELECT 
		zones."Zone",
		sum(trips."total_amount") total_amount
	FROM 
		public.taxi_trips trips
	INNER JOIN
		public.taxi_zones zones
	ON 
		trips."PULocationID"=zones."LocationID"
	WHERE 
		to_char(trips.lpep_pickup_datetime,'YYYY-mm-dd') = '2025-11-18'
	GROUP BY 
		zones."Zone"
),
 nov_18_max AS (
	SELECT
		"Zone",
		total_amount,
		RANK() OVER (ORDER BY total_amount DESC) AS RANK
	FROM
		nov_18_totals_by_zone
 )
 SELECT * FROM nov_18_max WHERE rank = 1;
;

-- Question 6
with largest_tip_in_East_Harlem_Nov_2025 as (
	SELECT 
		max(tip_amount) "largest_tip"
	FROM 
		public.taxi_trips trips
	INNER JOIN
		public.taxi_zones zones
	ON 
		trips."PULocationID"=zones."LocationID"
	WHERE
		zones."Zone" = 'East Harlem North'
		and 
		left(lpep_pickup_datetime::text,7) = '2025-11'
), drop_off_zone_for_largest_tip as (
	SELECT 
		zones."Zone"
	FROM 
		public.taxi_trips trips
	INNER JOIN
		public.taxi_zones zones
	ON 
		trips."DOLocationID"=zones."LocationID"
	WHERE 
		tip_amount in (SELECT * FROM largest_tip_in_East_Harlem_Nov_2025)

) SELECT * FROM drop_off_zone_for_largest_tip