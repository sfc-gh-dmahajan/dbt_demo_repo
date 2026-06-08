select
    order_id,
    customer_id,
    order_date,
    order_amount,
    order_status
from {{ source('demo_sources', 'orders') }}