-- models/marts/rpt_weekly_retailer_performance.sql
{{ config(materialized='table') }}

with fact as (
    select * from {{ ref('fct_retail_activity') }}
),

agg as (
    select
        period_ending_date,
        period_week_start,
        period_year,
        period_week_of_year,
        sps_retailer_name_key,
        count(distinct sps_item_mapping_key)      as distinct_items,
        count(distinct sps_customer_location_key) as distinct_stores,
        sum(net_sales_units)                      as net_sales_units,
        sum(net_sales_retail)                     as net_sales_retail,
        sum(inventory_units)                      as inventory_units,
        sum(est_sales_at_retail_value)            as est_sales_at_retail_value,
        avg(avg_unit_selling_price)               as avg_unit_selling_price,
        count(*)                                  as row_count
    from fact
    group by 1, 2, 3, 4, 5
)

select * from agg