{{ config(materialized='table') }}

-- Staging model for patient data from Fivetran GCS connector
-- Select all columns explicitly

select
    patient,
    date,
    age,
    sugar_level
from {{ source('gcs', 'test_results_data') }}