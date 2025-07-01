{{ config(materialized='table') }}

SELECT
    t.transaction_id,
    d.date_display        AS transaction_date,     -- formatted for reporting
    g.gender_id,
    c.city_id,
    card.card_type_id,
    t.exp_type,
    t.amount
FROM {{ ref('stg_transactions') }} t
LEFT JOIN {{ ref('dim_date') }} d 
    ON t.transaction_date = d.date_display     -- true DATE join
LEFT JOIN {{ ref('dim_gender') }} g 
    ON UPPER(t.gender) = UPPER(g.gender)
LEFT JOIN {{ ref('dim_city') }} c 
    ON t.city_raw = c.city
LEFT JOIN {{ ref('dim_card_type') }} card 
    ON UPPER(t.card_type) = UPPER(card.card_type)
