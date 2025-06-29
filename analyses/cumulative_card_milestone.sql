-- Q3: Cumulative spend for each card_type crossing 1M
with base as (
  select
    f.transaction_id,
    f.transaction_date,
    ct.card_type,
    f.amount,
    sum(f.amount) over (partition by ct.card_type order by f.transaction_date) as cumulative
  from {{ ref('fct_transactions') }} f
  join {{ ref('dim_card_type') }} ct on f.card_type_id = ct.card_type_id
),
ranked as (
  select *,
    row_number() over (partition by card_type order by transaction_date) as rn
  from base
  where cumulative >= 1000000
)
select *
from ranked
where rn = 1
