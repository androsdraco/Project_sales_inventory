with source as (
    select * from {{ source('retail', 'item') }}
),

cleaned as (
    select
        -- ── keys ──────────────────────────────────────────────────
        sps_item_mapping_key,
        sps_customer_item_key,
        sps_retailer_name_key,
        product_id,
        product_type_id,

        -- ── vendor ────────────────────────────────────────────────
        coalesce(nullif(trim(vendor_code), ''), 'UNKNOWN') as vendor_code,
        coalesce(nullif(trim(vendor_name), ''), 'UNKNOWN') as vendor_name,
        coalesce(nullif(trim(duns_number), ''), 'UNKNOWN') as duns_number,

        -- ── brand ─────────────────────────────────────────────────
        coalesce(nullif(trim(brand_code), ''), 'UNKNOWN') as brand_code,
        coalesce(nullif(trim(brand_name), ''), 'UNKNOWN') as brand_name,

        -- ── category hierarchy ────────────────────────────────────
        coalesce(nullif(trim(division_code), ''),         'UNKNOWN') as division_code,
        coalesce(nullif(trim(division_name), ''),         'UNKNOWN') as division_name,
        coalesce(nullif(trim(major_department_code), ''), 'UNKNOWN') as major_department_code,
        coalesce(nullif(trim(major_department_name), ''), 'UNKNOWN') as major_department_name,
        coalesce(nullif(trim(department_code), ''),       'UNKNOWN') as department_code,
        coalesce(nullif(trim(department_name), ''),       'UNKNOWN') as department_name,
        coalesce(nullif(trim(sub_department_code), ''),   'UNKNOWN') as sub_department_code,
        coalesce(nullif(trim(sub_department_name), ''),   'UNKNOWN') as sub_department_name,
        coalesce(nullif(trim(major_class_code), ''),      'UNKNOWN') as major_class_code,
        coalesce(nullif(trim(major_class_name), ''),      'UNKNOWN') as major_class_name,
        coalesce(nullif(trim(class_code), ''),            'UNKNOWN') as class_code,
        coalesce(nullif(trim(class_name), ''),            'UNKNOWN') as class_name,
        coalesce(nullif(trim(sub_class_code), ''),        'UNKNOWN') as sub_class_code,
        coalesce(nullif(trim(sub_class_name), ''),        'UNKNOWN') as sub_class_name,
        coalesce(nullif(trim(category_code), ''),         'UNKNOWN') as category_code,
        coalesce(nullif(trim(category_name), ''),         'UNKNOWN') as category_name,
        coalesce(nullif(trim(sub_category_code), ''),     'UNKNOWN') as sub_category_code,
        coalesce(nullif(trim(sub_category_name), ''),     'UNKNOWN') as sub_category_name,
        coalesce(nullif(trim(product_group_code), ''),    'UNKNOWN') as product_group_code,
        coalesce(nullif(trim(product_group_name), ''),    'UNKNOWN') as product_group_name,

        -- ── item descriptors ──────────────────────────────────────
        coalesce(nullif(trim(gender), ''),            'UNKNOWN') as gender,
        coalesce(nullif(trim(style_number), ''),      'UNKNOWN') as style_number,
        coalesce(nullif(trim(style_description), ''), 'UNKNOWN') as style_description,
        coalesce(nullif(trim(color_code), ''),        'UNKNOWN') as color_code,
        coalesce(nullif(trim(color_name), ''),        'UNKNOWN') as color_name,
        coalesce(nullif(trim(size_code), ''),         'UNKNOWN') as size_code,
        coalesce(nullif(trim(size_name), ''),         'UNKNOWN') as size_name,
        coalesce(nullif(trim(upc), ''),               'UNKNOWN') as upc,
        coalesce(nullif(trim(sku), ''),               'UNKNOWN') as sku,
        coalesce(nullif(trim(vendor_style_number), ''),      'UNKNOWN') as vendor_style_number,
        coalesce(nullif(trim(vendor_style_description), ''), 'UNKNOWN') as vendor_style_description,
        coalesce(nullif(trim(product_description), ''),      'UNKNOWN') as product_description,

        -- ── unit economics: cast varchar → number ────────────────
        -- ── unit economics: already NUMBER, use as-is ────────────
        corporate_unit_acquired_cost,
        corporate_unit_adjusted_cost,
        corporate_unit_owned_retail_price,
        msrp,
        cost,

        -- ── flags ─────────────────────────────────────────────────
        coalesce(nullif(trim(replenishment_indicator), ''), 'UNKNOWN') as replenishment_indicator,
        coalesce(nullif(trim(markdown_indicator), ''),      'UNKNOWN') as markdown_indicator,

        -- ── dates: cast varchar → date ───────────────────────────
        try_to_date(first_receipt_date::varchar) as first_receipt_date,
        try_to_date(last_receipt_date::varchar)  as last_receipt_date,

        -- ── remaining attributes ──────────────────────────────────
        coalesce(nullif(trim(product_season), ''),  'UNKNOWN') as product_season,
        coalesce(nullif(trim(age), ''),             'UNKNOWN') as age,
        coalesce(nullif(trim(unit_of_measure), ''), 'UNKNOWN') as unit_of_measure,
        coalesce(nullif(trim(fedas_code), ''),      'UNKNOWN') as fedas_code,
        coalesce(nullif(trim(sps_item_status), ''), 'UNKNOWN') as sps_item_status,

        -- ── audit ─────────────────────────────────────────────────
        insert_timestamp as _loaded_at

    from source
)

select * from cleaned