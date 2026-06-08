
  create or replace   view DBT_DATABASE.DBT_SCHEMA_DBT_SCHEMA.stg_customers
  
   as (
    select
    customer_id,
    customer_name,
    customer_segment,
    signup_date
from DBT_DATABASE.DBT_SCHEMA.CUSTOMERS
  );

