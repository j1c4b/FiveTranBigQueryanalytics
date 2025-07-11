{{ config(materialized='table') }}

-- Staging model for patient data from Fivetran GCS connector
-- Select all columns explicitly with proper casting

select
    cast(patient as string) as patient_id,
    cast(date as date) as visit_date,
    cast(age as int64) as patient_age,
    cast(sugar_level as int64) as blood_sugar_level
from {{ source('gcs', 'test_results_data') }}
where patient is not null