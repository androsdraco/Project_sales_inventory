with staging as (
    select * from {{ ref('stg_retail__item') }}
),

deduped as (
    select
        *,
        row_number() over (
            partition by sps_item_mapping_key
            order by _loaded_at desc
        ) as _rn
    from staging
)

select
    sps_item_mapping_key,
    sps_customer_item_key,
    sps_retailer_name_key,
    product_id,
    product_type_id,
    vendor_code,
    vendor_name,
    brand_code,
    brand_name,
    division_name,
    major_department_name,
    department_name,
    sub_department_name,
    major_class_name,
    class_name,
    sub_class_name,
    category_name,
    sub_category_name,
    product_group_name,
    gender,
    color_name,
    size_name,
    upc,
    sku,
    product_description,
    corporate_unit_acquired_cost,
    corporate_unit_adjusted_cost,
    corporate_unit_owned_retail_price,
    msrp,
    cost,
    product_season,
    unit_of_measure,
    sps_item_status,
    _loaded_at
from deduped
where _rn = 1