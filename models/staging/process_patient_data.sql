{{ config(materialized='table') }}

-- Staging model for patient data from Fivetran GCS connector
-- Simple select to test connectivity first

select *
from {{ source('gcs', 'test_results_data') }}
limit 10