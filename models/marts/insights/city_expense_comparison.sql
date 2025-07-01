-- Q5: High/low expense type per city
with spend as (
  select
    c.city,
    f.exp_type,
    sum(f.amount) as total
  from {{ ref('fct_transactions') }} f
  join {{ ref('dim_city') }} c on f.city_id = c.city_id
  group by c.city, f.exp_type
),
ranked as (
  select *,
    rank() over (partition by city order by total desc) as high_rank,
    rank() over (partition by city order by total asc) as low_rank
  from spend
)
select
  city,
  max(case when high_rank = 1 then exp_type end) as highest_expense_type,
  max(case when low_rank = 1 then exp_type end) as lowest_expense_type
from ranked
group by city
