{{ config(materialized='table') }}

-- Patient analytics mart for reporting and analysis

select
    patient_id,
    count(*) as total_visits,
    min(visit_date) as first_visit_date,
    max(visit_date) as last_visit_date,
    avg(patient_age) as avg_age,
    avg(blood_sugar_level) as avg_blood_sugar,
    min(blood_sugar_level) as min_blood_sugar,
    max(blood_sugar_level) as max_blood_sugar,
    case 
        when avg(blood_sugar_level) < 2 then 'Low'
        when avg(blood_sugar_level) between 2 and 4 then 'Normal'
        else 'High'
    end as blood_sugar_category
    
from {{ ref('process_patient_data') }}
group by patient_id