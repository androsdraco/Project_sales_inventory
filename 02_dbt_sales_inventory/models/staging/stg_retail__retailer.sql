with source as (
    select * from {{ source('retail', 'retailer_metadata') }}
),

cleaned as (
    select
        sps_retailer_name_key,
        coalesce(nullif(trim(activitygrain), ''), 'UNKNOWN') as activitygrain,
        current_timestamp() as _loaded_at
    from source
)

select * from cleaned