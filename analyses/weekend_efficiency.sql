-- Q9: Weekend efficiency ratio
with weekends as (
  select
    c.city,
    amount,
    extract(dow from d.date) as day_of_week
  from {{ ref('fct_transactions') }} f
  join {{ ref('dim_date') }} d on f.transaction_date = d.date_display
  join {{ ref('dim_city') }} c on f.city_id = c.city_id
  where extract(dow from d.date) in (0, 6)
),
agg as (
  select city, sum(amount) as total, count(*) as cnt
  from weekends
  group by city
),
r as (select
  city,
  round(total / cnt, 2) as avg_amount_per_txn
from agg
order by avg_amount_per_txn desc
limit 1)
select * from r
