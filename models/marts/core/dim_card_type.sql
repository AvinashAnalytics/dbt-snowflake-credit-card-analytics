{{ config(materialized='table') }}

select distinct
    upper(card_type) as card_type,
    md5(upper(card_type)) as card_type_id
from {{ ref('stg_transactions') }}
