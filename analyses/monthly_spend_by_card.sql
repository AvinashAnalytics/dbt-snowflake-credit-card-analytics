-- Q2: Top month per card type
select
  d.year,
  d.month,
  ct.card_type,
  sum(f.amount) as monthly_spend
from {{ ref('fct_transactions') }} f
join {{ ref('dim_card_type') }} ct on f.card_type_id = ct.card_type_id
join {{ ref('dim_date') }} d on f.transaction_date = d.date_display
group by d.year, d.month, ct.card_type
--order by d.year,d.month,monthly_spend desc
qualify row_number() over (partition by ct.card_type order by sum(f.amount) desc) = 1
