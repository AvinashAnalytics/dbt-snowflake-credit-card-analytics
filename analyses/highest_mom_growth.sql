-- Q7: Card + Exp type MoM growth
with monthly as (
  select
    ct.card_type,
    f.exp_type,
    d.year,
    d.month,
    sum(f.amount) as total_spend
  from {{ ref('fct_transactions') }} f
  join {{ ref('dim_date') }} d on f.transaction_date = d.date_display
  join {{ ref('dim_card_type') }} ct on f.card_type_id = ct.card_type_id
  group by ct.card_type, f.exp_type, d.year, d.month
),
growth as (
  select
    *,
    lag(total_spend) over (partition by card_type, exp_type order by year, month) as prev_month,
    (total_spend - lag(total_spend) over (partition by card_type, exp_type order by year, month)) / nullif(lag(total_spend) over (partition by card_type, exp_type order by year, month), 0) as growth_rate
  from monthly
) , r as (
select *
from growth
where year = 2014 and month = 1
order by growth_rate desc
limit 1)
select * from r
