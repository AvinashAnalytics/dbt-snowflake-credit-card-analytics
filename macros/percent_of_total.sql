{% macro percent_of_total(column, partition_by) %}
  100.0 * {{ column }} / sum({{ column }}) over (partition by {{ partition_by }})
{% endmacro %}
