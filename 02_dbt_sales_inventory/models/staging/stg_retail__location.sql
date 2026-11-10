with source as (
    select * from {{ source('retail', 'location') }}
),

cleaned as (
    select
        -- ── keys ──────────────────────────────────────────────────
        sps_customer_location_key,
        sps_retailer_name_key,
        location_id,
        coalesce(nullif(trim(retailer_name), ''), 'UNKNOWN') as retailer_name,

        -- ── store identity ────────────────────────────────────────
        coalesce(nullif(trim(store_number), ''), 'UNKNOWN') as store_number,
        coalesce(nullif(trim(store_name), ''),   'UNKNOWN') as store_name,

        -- ── address ───────────────────────────────────────────────
        coalesce(nullif(trim(address), ''),   'UNKNOWN') as address,
        coalesce(nullif(trim(address_2), ''), 'UNKNOWN') as address_2,
        coalesce(nullif(trim(city), ''),      'UNKNOWN') as city,
        coalesce(nullif(trim(state), ''),     'UNKNOWN') as state,
        coalesce(nullif(trim(postal_code), ''), 'UNKNOWN') as postal_code,
        coalesce(nullif(trim(country), ''),   'UNKNOWN') as country,
        coalesce(nullif(trim(sps_country), ''), 'UNKNOWN') as sps_country,
        coalesce(nullif(trim(sps_country_code), ''), 'UNKNOWN') as sps_country_code,

        -- ── store lifecycle (already DATE) ────────────────────────
        open_date,
        close_date,

        -- ── store attributes ──────────────────────────────────────
        coalesce(nullif(trim(mall), ''),         'UNKNOWN') as mall,
        coalesce(nullif(trim(sps_location_type), ''), 'UNKNOWN') as sps_location_type,
        coalesce(nullif(trim(location_type), ''), 'UNKNOWN') as location_type,
        coalesce(nullif(trim(store_rank), ''),   'UNKNOWN') as store_rank,
        coalesce(nullif(trim(store_classification), ''), 'UNKNOWN') as store_classification,
        coalesce(nullif(trim(store_size), ''),   'UNKNOWN') as store_size,

        -- ── geo: already NUMBER in Snowflake ──────────────────────
        sps_latitude,
        sps_longitude,

        -- ── organizational ────────────────────────────────────────
        coalesce(nullif(trim(region), ''),       'UNKNOWN') as region,
        coalesce(nullif(trim(demographic), ''),  'UNKNOWN') as demographic,
        coalesce(nullif(trim(climate), ''),      'UNKNOWN') as climate,
        coalesce(nullif(trim(comp_store_indicator), ''), 'UNKNOWN') as comp_store_indicator,
        coalesce(nullif(trim(retailer_division), ''), 'UNKNOWN') as retailer_division,
        coalesce(nullif(trim(banner), ''),       'UNKNOWN') as banner,
        coalesce(nullif(trim(gln), ''),          'UNKNOWN') as gln,
        coalesce(nullif(trim(currency_code), ''), 'UNKNOWN') as currency_code,

        -- ── audit ─────────────────────────────────────────────────
        insert_timestamp as _loaded_at,
        try_to_timestamp(update_timestamp::varchar) as update_timestamp

    from source
)

select * from cleaned