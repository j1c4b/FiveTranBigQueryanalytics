-- Test connection to GCS source
select count(*) as row_count
from {{ source('gcs', 'test_results_data') }}