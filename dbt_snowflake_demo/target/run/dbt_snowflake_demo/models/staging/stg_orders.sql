
  create or replace   view DBT_DATABASE.DBT_SCHEMA_DBT_SCHEMA.stg_orders
  
   as (
    select
    order_id,
    customer_id,
    order_date,
    order_amount,
    order_status
from DBT_DATABASE.DBT_SCHEMA.ORDERS
  );

