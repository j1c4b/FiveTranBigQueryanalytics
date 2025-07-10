# FiveTran BigQuery Analytics

A dbt project for processing patient data from GCP bucket CSV files into BigQuery for analytics.

## Project Overview

This project processes patient data from a CSV file stored in Google Cloud Storage bucket and transforms it into analytical tables in BigQuery using dbt (data build tool).

**Data Source**: `gs://fivetran-staging-demo/test_patient_data.csv`

## Project Structure

```
├── dbt_project.yml          # dbt project configuration
├── profiles.yml             # BigQuery connection settings
├── models/
│   ├── staging/
│   │   ├── stg_csv_data.sql # Staging model for patient data
│   │   └── schema.yml       # Model documentation and tests
│   └── marts/
│       └── patient_analytics.sql # Patient analytics mart
├── tests/                   # Custom data tests
├── macros/                  # SQL macros
├── seeds/                   # Static data files
└── dbt_env/                 # Python virtual environment
```

## Setup Instructions

### 1. Prerequisites

- Python 3.8+
- Google Cloud SDK (`gcloud`)
- BigQuery access with service account
- Access to GCP bucket: `gs://fivetran-staging-demo/`

### 2. Environment Setup

```bash
# Create virtual environment
python3 -m venv dbt_env

# Activate virtual environment
source dbt_env/bin/activate

# Install dbt with BigQuery adapter
pip install dbt-bigquery
```

### 3. Configuration

Update `profiles.yml` with your BigQuery details:

```yaml
my_patient_project:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: service-account
      keyfile: /path/to/your/service-account-key.json
      project: your-gcp-project-id
      dataset: your-dataset-name
      threads: 4
      timeout_seconds: 300
      location: US
```

### 4. Data Loading

Load the CSV data into BigQuery:

```bash
# Load patient data from GCP bucket
bq load --source_format=CSV --skip_leading_rows=1 --autodetect \
  your-project:your-dataset.raw_patient_data \
  gs://fivetran-staging-demo/test_patient_data.csv
```

## Running the Project

### 1. Test Connection

```bash
source dbt_env/bin/activate
dbt debug
```

### 2. Run Models

```bash
# Run all models
dbt run

# Run specific model
dbt run --models stg_csv_data
```

### 3. Run Tests

```bash
# Run all tests
dbt test

# Run tests for specific model
dbt test --models stg_csv_data
```

### 4. Generate Documentation

```bash
# Generate and serve documentation
dbt docs generate
dbt docs serve
```

## Data Models

### Staging Layer

**`stg_csv_data`**
- **Purpose**: Clean and standardize patient data from CSV
- **Materialization**: Table
- **Columns**:
  - `patient_id` (STRING): Patient identifier
  - `visit_date` (DATE): Visit date
  - `patient_age` (INT64): Patient age in years
  - `blood_sugar_level` (INT64): Blood sugar level measurement

### Marts Layer

**`patient_analytics`**
- **Purpose**: Aggregated patient metrics for analytics
- **Materialization**: Table
- **Columns**:
  - `patient_id` (STRING): Patient identifier
  - `total_visits` (INT64): Total number of visits
  - `first_visit_date` (DATE): First visit date
  - `last_visit_date` (DATE): Last visit date
  - `avg_age` (FLOAT64): Average age
  - `avg_blood_sugar` (FLOAT64): Average blood sugar level
  - `min_blood_sugar` (INT64): Minimum blood sugar level
  - `max_blood_sugar` (INT64): Maximum blood sugar level
  - `blood_sugar_category` (STRING): Blood sugar category (Low/Normal/High)

## Data Quality Tests

The project includes comprehensive data quality tests:

- **Not Null Tests**: Ensure critical fields are not null
- **Unique Tests**: Ensure patient IDs are unique in analytics
- **Custom Tests**: Validate data ranges and business logic

## Querying Results

Query the analytics table:

```sql
SELECT * FROM `your-project.your-dataset.patient_analytics`
WHERE blood_sugar_category = 'High'
ORDER BY avg_blood_sugar DESC;
```

## Troubleshooting

### Common Issues

1. **Connection Issues**
   - Verify service account permissions
   - Check BigQuery dataset exists in correct location
   - Validate profiles.yml configuration

2. **Data Loading Issues**
   - Ensure GCP bucket access permissions
   - Verify CSV file format and structure
   - Check BigQuery table schema

3. **Model Failures**
   - Run `dbt debug` to test connections
   - Check compiled SQL in `target/` directory
   - Verify source table exists and has data

### Useful Commands

```bash
# Check dbt version
dbt --version

# Validate project structure
dbt parse

# Run with verbose logging
dbt run --log-level debug

# Test specific model
dbt test --models patient_analytics
```

## Development

### Adding New Models

1. Create SQL file in appropriate directory (`models/staging/` or `models/marts/`)
2. Add model documentation to `schema.yml`
3. Add data quality tests
4. Run `dbt run` and `dbt test`

### Best Practices

- Use consistent naming conventions
- Add comprehensive documentation
- Include data quality tests for all models
- Use appropriate materializations (view vs table)
- Follow SQL style guide

## License

This project is licensed under the MIT License.
