with source as (
    select * from {{ source('retail', 'activity') }}
),

cleaned as (
    select
        -- ── fact grain ────────────────────────────────────────────
        sps_customer_item_key,
        sps_customer_location_key,
        sps_retailer_name_key,
        sps_item_mapping_key,

        -- ── date: NUMBER(YYYYMMDD) → date ─────────────────────────
        try_to_date(period_ending_date::varchar, 'YYYYMMDD') as period_ending_date,

        -- ── net sales / inventory (already NUMBER) ────────────────
        net_sales_units,
        net_sales_retail,
        inventory_units,
        try_to_number(inventory_adjustment_units::varchar, 18, 0) as inventory_adjustment_units,

        -- ── unit economics (already NUMBER) ───────────────────────
        corporate_unit_adjusted_cost,
        corporate_unit_acquired_cost,
        corporate_unit_owned_retail_price,

        -- ── audit ─────────────────────────────────────────────────
        insert_timestamp as _loaded_at

    from source
    where period_ending_date is not null
)

select * from cleaned