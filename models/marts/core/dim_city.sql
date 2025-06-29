{{ config(materialized='table') }}

select distinct
    city_raw as city,
    md5(city_raw) as city_id
from {{ ref('stg_transactions') }}
