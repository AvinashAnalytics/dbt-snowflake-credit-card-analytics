{{ config(materialized='table') }}

select distinct
    upper(gender) as gender,
    md5(gender) as gender_id
from {{ ref('stg_transactions') }}
