-- Q4: City with lowest % spend for Gold
with gold_spend as (
  select
    c.city,
    sum(f.amount) as spend
  from {{ ref('fct_transactions') }} f
  join {{ ref('dim_card_type') }} ct on f.card_type_id = ct.card_type_id
  join {{ ref('dim_city') }} c on f.city_id = c.city_id
  where ct.card_type = 'GOLD'
  group by c.city
),
total as (
  select sum(spend) as total_spend from gold_spend
), result as (
select
  city,
  spend,
  round(spend / total_spend * 100, 2) as pct
from gold_spend, total
order by pct asc
limit 1
)
select * from result