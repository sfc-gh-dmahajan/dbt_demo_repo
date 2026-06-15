# dbt_snowflake_demo

A dbt project deployed on Snowflake that transforms raw customer and order data into analytical models.

## Project Structure

```
dbt_snowflake_demo/
├── dbt_project.yml
├── profiles.yml
├── models/
│   ├── sources.yml
│   ├── schema.yml
│   ├── staging/
│   │   ├── stg_customers.sql        (view)
│   │   └── stg_orders.sql           (view)
│   └── marts/
│       ├── customer_order_summary.sql      (table)
│       └── customer_order_summary_view.sql (view)
```

## Source Data

| Source Table | Database | Schema |
|---|---|---|
| CUSTOMERS | DBT_DATABASE | DBT_SCHEMA |
| ORDERS | DBT_DATABASE | DBT_SCHEMA |

## Models

### Staging (materialized as views)

- **stg_customers** - Selects customer_id, customer_name, customer_segment, signup_date from source
- **stg_orders** - Selects order_id, customer_id, order_date, order_amount, order_status from source

### Marts (materialized as tables/views)

- **customer_order_summary** (table) - Aggregates orders per customer: total_orders, total_order_amount, average_order_amount, most_recent_order_date
- **customer_order_summary_view** (view) - Adds a `customer_value_band` classification (high_value / standard / new_or_low_value) on top of the summary

## Configuration

| Setting | Value |
|---|---|
| Profile | dbt_snowflake_demo |
| Database | DBT_DATABASE |
| Schema | DBT_SCHEMA |
| Warehouse | CORTEX_WH |
| Role | ACCOUNTADMIN |
| Targets | dev, qa |

## Deployment

This project is deployed as a Snowflake dbt project object:

```sql
CREATE OR REPLACE DBT PROJECT DBT_DATABASE.DBT_SCHEMA.DBT_SNOWFLAKE_DEMO
  FROM snow://workspace/USER$DMAHAJAN.PUBLIC."dbt_demo_repo"/versions/live/dbt_snowflake_demo/
  DBT_VERSION='1.9.4'
  DEFAULT_TARGET='dev';
```

## Running

From the workspace:
```
dbt run --project-dir dbt_snowflake_demo
dbt test --project-dir dbt_snowflake_demo
```

## Installing dbt Packages

### Prerequisites

To download packages from dbt Hub or GitHub, you need an External Access Integration that allows outbound network access.

### 1. Create a Network Rule

```sql
CREATE OR REPLACE NETWORK RULE DBT_DATABASE.DBT_SCHEMA.DBT_HUB_NETWORK_RULE
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('hub.getdbt.com', 'github.com', 'codeload.github.com');
```

### 2. Create an External Access Integration

```sql
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION DBT_PACKAGES_EAI
  ALLOWED_NETWORK_RULES = (DBT_DATABASE.DBT_SCHEMA.DBT_HUB_NETWORK_RULE)
  ENABLED = TRUE;
```

### 3. Declare packages

Create a `packages.yml` file inside the dbt project directory (`dbt_snowflake_demo/packages.yml`):

```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: ">=1.0.0"
  - package: calogica/dbt_expectations
    version: ">=0.10.0"
```

### 4. Install packages in the workspace

```
dbt deps --project-dir dbt_snowflake_demo
```

### 5. Deploy/Execute with EAI attached

When deploying or executing via SQL, include the integration:

```sql
CREATE OR REPLACE DBT PROJECT DBT_DATABASE.DBT_SCHEMA.DBT_SNOWFLAKE_DEMO
  FROM '@<your_stage>/dbt_snowflake_demo'
  EXTERNAL_ACCESS_INTEGRATIONS = (DBT_PACKAGES_EAI);
```

```sql
EXECUTE DBT PROJECT DBT_DATABASE.DBT_SCHEMA.DBT_SNOWFLAKE_DEMO
  ARGS = 'deps'
  EXTERNAL_ACCESS_INTEGRATIONS = (DBT_PACKAGES_EAI);
```

```sql
EXECUTE DBT PROJECT DBT_DATABASE.DBT_SCHEMA.DBT_SNOWFLAKE_DEMO
  ARGS = 'run'
  EXTERNAL_ACCESS_INTEGRATIONS = (DBT_PACKAGES_EAI);
```

> **Note:** The `EXTERNAL_ACCESS_INTEGRATIONS = (DBT_PACKAGES_EAI)` parameter is what grants the runtime permission to reach hub.getdbt.com and download packages. Without it, `dbt deps` will fail with a connection error.

---

## Secret and API Integration creation


```sql
CREATE OR REPLACE SECRET dbt_git_secret
  TYPE = password
  USERNAME = 'sfc-gh-dmahajan'
  PASSWORD = '<PAT>';

-- API Integration
CREATE OR REPLACE API INTEGRATION my_dbt_git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/sfc-gh-dmahajan')
  ALLOWED_AUTHENTICATION_SECRETS = (dbt_git_secret)
  ENABLED = TRUE;
```
