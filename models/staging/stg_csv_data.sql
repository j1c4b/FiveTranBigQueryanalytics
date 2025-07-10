{{ config(materialized='table') }}

-- Staging model for patient data from Fivetran connector
-- Processes patient data through Fivetran's data pipeline

select
    cast(patient as string) as patient_id,
    cast(date as date) as visit_date,
    cast(age as int64) as patient_age,
    cast(sugar_level as int64) as blood_sugar_level
    
from {{ source('fivetran_staging', 'test_patient_data') }}

-- Add basic data quality checks
where patient is not null
  and date is not null
  and age > 0
  and sugar_level > 0