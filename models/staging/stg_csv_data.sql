{{ config(materialized='table') }}

-- Staging model for patient data from GCP bucket
-- Source: https://storage.googleapis.com/fivetran-staging-demo/test_patient_data.csv

select
    cast(patient as string) as patient_id,
    cast(date as date) as visit_date,
    cast(age as int64) as patient_age,
    cast(sugar_level as int64) as blood_sugar_level
    
from (
  select 
    patient,
    date,
    age,
    sugar_level
  from `fivetran01.five_tran_staging.raw_patient_data`
)

-- Add basic data quality checks
where patient is not null
  and date is not null
  and age > 0
  and sugar_level > 0