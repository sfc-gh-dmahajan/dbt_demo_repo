
    
    

select
    customer_id as unique_field,
    count(*) as n_records

from DBT_DATABASE.DBT_SCHEMA_DBT_SCHEMA.customer_order_summary_view
where customer_id is not null
group by customer_id
having count(*) > 1


