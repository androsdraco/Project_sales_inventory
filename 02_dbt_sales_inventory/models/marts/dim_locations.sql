with staging as (
    select * from {{ ref('stg_retail__location') }}
)

select
    sps_customer_location_key,
    sps_retailer_name_key,
    location_id,
    retailer_name,
    store_number,
    store_name,
    city,
    state,
    postal_code,
    country,
    sps_country_code,
    region,
    demographic,
    climate,
    location_type,
    store_classification,
    store_size,
    comp_store_indicator,
    banner,
    sps_latitude,
    sps_longitude,
    open_date,
    close_date,
    currency_code,
    _loaded_at
from staging