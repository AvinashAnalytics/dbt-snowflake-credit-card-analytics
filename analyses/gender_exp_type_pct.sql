-- Q6: Female spend % per expense type
with exp_spend as (
  select
    exp_type,
    gender_id,
    sum(amount) as total
  from {{ ref('fct_transactions') }}
  group by exp_type, gender_id
),
gender_map as (
  select gender_id from {{ ref('dim_gender') }} where gender = 'F'
),
female as (
  select e.exp_type, e.total as female_spend
  from exp_spend e
  join gender_map g on e.gender_id = g.gender_id
),
total_exp as (
  select exp_type, sum(total) as total_spend
  from exp_spend
  group by exp_type
)
select
  t.exp_type,
  round(f.female_spend / t.total_spend * 100, 2) as pct_female
from total_exp t
join female f on t.exp_type = f.exp_type
