{{ config(materialized='table') }}

WITH dates AS (
  {{ dbt_utils.date_spine(
    start_date="cast('2013-01-01' as date)",
    end_date="cast('2015-12-31' as date)",
    datepart="day"
  ) }}
)

SELECT
  date_day AS date,                                   -- joinable key
  TO_VARCHAR(date_day, 'DD-MM-YYYY') AS date_display, -- human-friendly format
  EXTRACT(YEAR  FROM date_day) AS year,
  EXTRACT(MONTH FROM date_day) AS month,
  EXTRACT(DAY   FROM date_day) AS day,
  EXTRACT(DOW   FROM date_day) AS day_of_week,
  EXTRACT(WEEK  FROM date_day) AS week
FROM dates
