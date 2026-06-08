

select
    customers.customer_id,
    customers.customer_name,
    customers.customer_segment,
    customers.signup_date,
    count(orders.order_id) as total_orders,
    coalesce(sum(orders.order_amount), 0) as total_order_amount,
    coalesce(avg(orders.order_amount), 0) as average_order_amount,
    max(orders.order_date) as most_recent_order_date
from DBT_DATABASE.DBT_SCHEMA_DBT_SCHEMA.stg_customers as customers
left join DBT_DATABASE.DBT_SCHEMA_DBT_SCHEMA.stg_orders as orders
    on customers.customer_id = orders.customer_id
group by
    customers.customer_id,
    customers.customer_name,
    customers.customer_segment,
    customers.signup_date