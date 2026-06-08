select
    customer_id,
    customer_name,
    customer_segment,
    signup_date
from {{ source('demo_sources', 'customers') }}