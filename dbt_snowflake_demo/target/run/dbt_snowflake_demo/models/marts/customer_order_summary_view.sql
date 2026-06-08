
  create or replace   view DBT_DATABASE.DBT_SCHEMA_DBT_SCHEMA.customer_order_summary_view
  
   as (
    

select
    customer_id,
    customer_name,
    customer_segment,
    signup_date,
    total_orders,
    total_order_amount,
    average_order_amount,
    most_recent_order_date,
    case
        when total_order_amount >= 500 then 'high_value'
        when total_order_amount >= 100 then 'standard'
        else 'new_or_low_value'
    end as customer_value_band
from DBT_DATABASE.DBT_SCHEMA_DBT_SCHEMA.customer_order_summary
  );

