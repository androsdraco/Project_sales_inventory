with date_spine as (
    select dateadd(day, seq4(), '2024-01-01'::date)::date as date_day
    from table(generator(rowcount => 366))
),

final as (
    select
        date_day,
        year(date_day)                                 as year,
        quarter(date_day)                              as quarter,
        month(date_day)                                as month,
        monthname(date_day)                            as month_name,
        weekofyear(date_day)                           as week_of_year,
        dayofweek(date_day)                            as day_of_week_num,
        dayname(date_day)                              as day_of_week_name,
        day(date_day)                                  as day_of_month,
        date_trunc('week', date_day)::date             as week_start,
        date_trunc('month', date_day)::date            as month_start,
        date_trunc('quarter', date_day)::date          as quarter_start,
        date_trunc('year', date_day)::date             as year_start,
        case when dayofweek(date_day) in (0, 6) then true else false end as is_weekend
    from date_spine
)

select * from final