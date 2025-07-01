{% macro generate_schema_name(custom_schema_name, node) %}
  {# 1️⃣ If you’ve explicitly set +schema: in YAML, use that and stop #}
  {% if custom_schema_name is not none %}
    {{ custom_schema_name }}

  {# a2️⃣ Otherwise, check the model’s filename prefix #}
  {% else %}
    {%- set name = node.name -%}

    {%- if name.startswith('stg_') -%}
      {{ 'stg' }}
    {%- elif name.startswith('fct_') or name.startswith('dim_') -%}
      {{ 'mart' }}
    {%- else -%}
      {{ target.schema }}
    {%- endif -%}
  {% endif %}
{% endmacro %}
