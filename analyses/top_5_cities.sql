-- Q1: Top 5 cities by spend + % of total
with city_spend as (
  select
    c.city,
    sum(f.amount) as total_spend
  from {{ ref('fct_transactions') }} f
  join {{ ref('dim_city') }} c on f.city_id = c.city_id
  group by c.city
),
total as (
  select sum(total_spend) as all_spend from city_spend
),
rank_spend as (select
  city,
  total_spend,
  round((total_spend / all_spend) * 100, 2) as pct_contribution
from city_spend, total
order by total_spend desc
limit 5)
select * from rank_spend
