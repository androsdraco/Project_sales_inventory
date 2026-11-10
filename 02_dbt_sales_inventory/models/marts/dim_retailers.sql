with staging as (
    select * from {{ ref('stg_retail__retailer') }}
),

fact_revenue as (
    select
        sps_retailer_name_key,
        sum(net_sales_retail) as total_revenue
    from {{ ref('stg_retail__activity') }}
    group by 1
),

final as (
    select
        s.sps_retailer_name_key,
        s.activitygrain,
        case 
            when coalesce(f.total_revenue, 0) > 0 then true 
            else false 
        end as has_revenue_data,
        s._loaded_at
    from staging s
    left join fact_revenue f using (sps_retailer_name_key)
)

select * from final