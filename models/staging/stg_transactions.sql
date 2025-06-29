WITH source AS (
  SELECT * FROM {{ source('dbt_raw_data', 'trns') }}
),

cleaned AS (
  SELECT
    CAST(transaction_id AS INTEGER) AS transaction_id,
    INITCAP(TRIM(city)) AS city_raw,

    -- Fix legacy-style years like 0014 ➜ 2014
    TO_DATE(
      REGEXP_REPLACE(transaction_date, '^00', '20'),
      'YYYY-MM-DD'
    ) AS transaction_date_actual,

    -- Format as DD-MM-YYYY
    TO_VARCHAR(
      TO_DATE(REGEXP_REPLACE(transaction_date, '^00', '20'), 'YYYY-MM-DD'),
      'DD-MM-YYYY'
    ) AS transaction_date,

    UPPER(TRIM(card_type)) AS card_type,
    INITCAP(TRIM(exp_type)) AS exp_type,
    UPPER(TRIM(gender)) AS gender,
    TRY_CAST(REPLACE(amount, ' ', '') AS NUMBER) AS amount
  FROM source
)
SELECT * FROM cleaned