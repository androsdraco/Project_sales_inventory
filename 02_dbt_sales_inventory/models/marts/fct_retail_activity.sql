with activity as (
    select * from {{ ref('stg_retail__activity') }}
),

dates as (
    select * from {{ ref('dim_dates') }}
),

final as (
    select
        -- ── composite fact key (unique row per period × item × location) ─
        a.sps_customer_item_key || '|' 
        || a.sps_customer_location_key || '|' 
        || cast(a.period_ending_date as varchar) as fact_key,

        -- ── foreign keys to dims ──────────────────────────────────────
        a.period_ending_date,
        a.sps_item_mapping_key,
        a.sps_customer_location_key,
        a.sps_retailer_name_key,

        -- ── degenerate dims (from date dim) ───────────────────────────
        d.year                                        as period_year,
        d.quarter                                     as period_quarter,
        d.month                                       as period_month,
        d.week_of_year                                as period_week_of_year,
        d.week_start                                  as period_week_start,

        -- ── measures ──────────────────────────────────────────────────
        a.net_sales_units,
        a.net_sales_retail,
        a.inventory_units,
        a.inventory_adjustment_units,
        a.corporate_unit_adjusted_cost,
        a.corporate_unit_acquired_cost,
        a.corporate_unit_owned_retail_price,

        -- ── derived measures (useful for BI without extra DAX) ────────
        a.net_sales_units * a.corporate_unit_owned_retail_price 
            as est_sales_at_retail_value,
        case when a.net_sales_units = 0 then null
             else a.net_sales_retail / a.net_sales_units end 
            as avg_unit_selling_price,

        -- ── audit ─────────────────────────────────────────────────────
        a._loaded_at,
        current_timestamp()                           as _fact_built_at

    from activity a
    left join dates d 
        on a.period_ending_date = d.date_day
    where a.period_ending_date is not null
)

select * from final